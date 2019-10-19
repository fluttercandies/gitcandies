class Scopes {
  static Scopes _instance = Scopes._();
  Scopes._();
  factory Scopes() => _instance;

  /// Scopes for repositories.
  final repositories = "repo";
  final repositoriesPublic = "public_repo";
  final repositoriesStatus = "repo:status";
  final repositoriesDelete = "delete_repo";
  final repositoriesDeployment = "repo_deployment";
  final repositoriesInvitation = "repo:invite";
  final repositoriesHooksAdministration = "admin:repo_hook";
  final repositoriesHooksWrite = "write:repo_hook";
  final repositoriesHooksRead = "read:repo_hook";

  /// Scopes for organizations.
  final organizationsAdministration = "admin:org";
  final organizationsWrite = "write:org";
  final organizationsRead = "read:org";
  /// Note: [admin:org_hook] will only take effect on those hooks created by
  /// your OAuth app.
  final organizationsHooksAdministration = "admin:org_hook";

  /// Scopes for public key.
  final publicKeyAdministration = "admin:public_key";
  final publicKeyWrite = "write:public_key";
  final publicKeyRead = "read:public_key";

  /// Scopes for user.
  final user = "user";
  final userRead = "read:user";
  final userEmail = "user:email";
  final userFollow = "user:follow";

  /// Scopes for discussion.
  final discussionWriteAndRead = "write:discussion";
  final discussionRead = "read:discussion";

  /// Scopes for packages.
  final packagesPublishAndDelete = "write:packages";
  final packagesDownload = "read:packages";

  /// Scopes for GPG Key.
  final gpgKeyAdministration = "admin:gpg_key";
  final gpgKeyWrite = "wrtie:gpg_key";
  final gpgKeyRead = "read:gpg_key";

  /// Scopes for gist.
  final gist = "gist";

  /// Scopes for notifications.
  final notifications = "notifications";

  /// Scopes for workflow.
  final workflow = "workflow";
}