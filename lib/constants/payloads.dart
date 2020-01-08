///
/// [Author] Alex (https://github.com/AlexVicnent525)
/// [Date] 2019-10-25 16:17
///
import 'package:github/github.dart';
import "package:json_annotation/json_annotation.dart";

/// API doc: https://developer.github.com/v3/activity/events/types
enum EventType {
  CheckRunEvent,
  CheckSuiteEvent,
  CommitCommentEvent,
  ContentReferenceEvent,
  CreateEvent,
  DeleteEvent,
  DeployKeyEvent,
  DeploymentEvent,
  DeploymentStatusEvent,
  DownloadEvent,
  FollowEvent,
  ForkEvent,
  ForkApplyEvent,
  GitHubAppAuthorizationEvent,
  GistEvent,
  GollumEvent,
  InstallationEvent,
  InstallationRepositoriesEvent,
  IssueCommentEvent,
  IssuesEvent,
  LabelEvent,
  MarketplacePurchaseEvent,
  MemberEvent,
  MembershipEvent,
  MetaEvent,
  MilestoneEvent,
  OrganizationEvent,
  OrgBlockEvent,
  PageBuildEvent,
  ProjectCardEvent,
  ProjectColumnEvent,
  ProjectEvent,
  PublicEvent,
  PullRequestEvent,
  PullRequestReviewEvent,
  PullRequestReviewCommentEvent,
  PushEvent,
  RegistryPackageEvent,
  ReleaseEvent,
  RepositoryDispatchEvent,
  RepositoryEvent,
  RepositoryImportEvent,
  RepositoryVulnerabilityAlertEvent,
  SecurityAdvisoryEvent,
  StarEvent,
  StatusEvent,
  TeamEvent,
  TeamAddEvent,
  WatchEvent,
}

class IssueCommentEventPayload {
  @JsonKey(name: "action")
  String action;

  @JsonKey(name: "changes")
  Object changes;

  @JsonKey(name: "issue")
  Issue issue;

  @JsonKey(name: "comment")
  IssueComment comment;

  static IssueCommentEventPayload fromJSON(Map<String, dynamic> input) {
    if (input == null) return null;

    return IssueCommentEventPayload()
      ..action = input['action']
      ..changes = input['changes']
      ..issue = Issue.fromJson(input['issue'])
      ..comment = IssueComment.fromJson(input['comment']);
  }
}
