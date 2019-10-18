import 'package:gitav/provider/base_provider.dart';
import 'package:github/server.dart';
import 'package:oktoast/oktoast.dart';

class LoginProvider extends BaseProvider {
  Future<void> loginWithToken(String token) async {
    if (token == null || token.trim().isEmpty) {
      showToast("The token must not be null.");
      return;
    }
    final auth = Authentication.withToken(token);
    var client = createGitHubClient(auth: auth);
    final user = await client.users.getCurrentUser();
    print(user.name);
  }
}
