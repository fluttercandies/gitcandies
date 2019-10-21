import 'dart:convert';

import 'package:github/server.dart';
import 'package:oktoast/oktoast.dart';

import 'package:gitcandies/configs/oauth_config.dart';
import 'package:gitcandies/constants/apis.dart';
import 'package:gitcandies/pages/login_page.dart';
import 'package:gitcandies/pages/main_page.dart';
import 'package:gitcandies/providers/base_provider.dart';
import 'package:gitcandies/providers/user_provider.dart';
import 'package:gitcandies/utils/shared_preferences_utils.dart';

class LoginProvider extends BaseProvider {
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
      showToast("Login fail");
    }
  }

  Future<void> loginWithBasic(String username, String password) async {
    if (!checkInputEmpty(username, makeEmptyTip("username")) ||
        !checkInputEmpty(password, makeEmptyTip("password"))) {
      return;
    }

    final bytes = utf8.encode("$username:$password");
    final baseStr = base64.encode(bytes);

    final response = await httpUtils.post("${API.host}/authorizations", {
      "Accept": "application/json",
      "Authorization": "Basic $baseStr"
    }, {
      "scopes": [
        scopes.user,
        scopes.gist,
        scopes.repositories,
        scopes.notifications,
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
      return;
    }
    loginWithToken(token);
  }

  _onLoginSuccess(GitHub client, CurrentUser user, String token) async {
    await SpUtils.setToken(token);
    github = client;
    final userProvider = getProvider<UserProvider>();
    userProvider.currentUser = user;

    route.pushWidget(
      MainPage(),
      replaceRoot: true,
    );
  }

  logout() async {
    showToast("See you next time :>");
    github = null;
    final userProvider = getProvider<UserProvider>();
    userProvider.currentUser = null;
    await SpUtils.removeToken();

    route.pushWidget(
      LoginPage(),
      replaceRoot: true,
    );
  }
}
