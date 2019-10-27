import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github/server.dart';
import 'package:oktoast/oktoast.dart';

import 'package:gitcandies/configs/oauth_config.dart';
import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/pages/login_page.dart';
import 'package:gitcandies/providers/providers.dart';
import 'package:gitcandies/utils/utils.dart';

class LoginProvider extends BaseProvider {
  bool logging = false;

  void checkLogin() {
    if (SpUtils.hasToken) {
      loginWithToken(SpUtils.token);
    } else {
      RouteHelper().pushRoute(
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: LoginPage(),
          ),
        ),
        replaceCurrent: true,
      );
    }
  }

  Future<void> loginWithToken(String token) async {
    if (!checkInputEmpty(token, makeEmptyTip("token"))) {
      showToast("The token must not be null.");
      return;
    }
    final auth = Authentication.withToken(token);
    try {
      GitHub client = createGitHubClient(auth: auth);
      final user = await client.users.getCurrentUser();
      _onLoginSuccess(client, user, token);
    } catch (e) {
      print(e);

      logging = false;
      notifyListeners();

      if (e is AccessForbidden) {
        route.router
            .pushNamedAndRemoveUntil("/loginpage", (Route route) => false);
      } else {
        showToast("Login fail");
      }
    }
  }

  Future<void> loginWithBasic(String username, String password) async {
    if (!checkInputEmpty(username, makeEmptyTip("username")) ||
        !checkInputEmpty(password, makeEmptyTip("password"))) {
      return;
    }

    logging = true;
    notifyListeners();

    final bytes = utf8.encode("$username:$password");
    final baseStr = base64.encode(bytes);

    final response = await httpUtils.post("${API.host}/authorizations", {
      "Accept": "application/json",
      "Authorization": "Basic $baseStr"
    }, {
      "scopes": [
        scopes.user,
        scopes.gist,
        scopes.workflow,
        scopes.repositories,
        scopes.notifications,
        scopes.publicKeyAdministration,
        scopes.gpgKeyAdministration,
        scopes.discussionWriteAndRead,
        scopes.organizationsRead,
        scopes.organizationsAdministration,
      ],
      "note": "admin_script",
      "client_id": OAuthConfig.clientId,
      "client_secret": OAuthConfig.clientSecret,
    });

    final map = json.decode(response);
    var token = map["token"];
    if (token == null) {
      showToast("Login fail.");
      logging = false;
      notifyListeners();
      return;
    }
    loginWithToken(token);
  }

  void _onLoginSuccess(GitHub client, CurrentUser user, String token) async {
    await SpUtils.setToken(token);
    github = client;
    final userProvider = getProvider<UserProvider>();
    userProvider.currentUser = user;

    logging = false;

    route.router.pushNamedAndRemoveUntil("/mainpage", (Route route) => false);
  }

  void logout() async {
    showToast("See you next time :>");
    github = null;
    final userProvider = getProvider<UserProvider>();
    userProvider.currentUser = null;
    await SpUtils.removeToken();

    route.router.pushNamedAndRemoveUntil("/loginpage", (Route route) => false);
  }
}
