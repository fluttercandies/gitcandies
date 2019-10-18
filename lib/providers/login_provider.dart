import 'dart:convert';

import 'package:gitav/configs/oauth_config.dart';
import 'package:gitav/constants/apis.dart';
import 'package:gitav/pages/main_page.dart';
import 'package:gitav/provider/base_provider.dart';
import 'package:gitav/provider/user_provider.dart';
import 'package:github/server.dart';
import 'package:oktoast/oktoast.dart';

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

  Future<void> loginWithBasic(
      String username, String password) async {
    if (!checkInputEmpty(username, makeEmptyTip("username")) ||
        !checkInputEmpty(password, makeEmptyTip("username"))) {
      return;
    }

    final bytes = utf8.encode("$username:$password");
    final baseStr = base64.encode(bytes);

    final response =
        await httpUtils.post("${API.host}/authorizations", {
      "Accept": "application/json",
      "Authorization": "Basic $baseStr"
    }, {
      "scopes": ["user", "repo", "gist", "notifications"],
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

  _onLoginSuccess(GitHub client, CurrentUser user, String token) {
    github = client;
    final userProvider = getProvider<UserProvider>();
    userProvider.currentUser = user;
    showToast("登录成功");

    // Todo: Save token to SP.
    route.pushWidget(
      MainPage(
        title: "home",
      ),
      replaceRoot: true,
    );
  }
}
