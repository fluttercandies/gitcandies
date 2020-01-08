import 'package:flutter/material.dart';
import 'package:github/github.dart' as GitHub;

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/providers/providers.dart';

class ActivitiesPage extends StatelessWidget {
  final avatarSize = 64.0;

  Widget events(ActivitiesProvider provider) {
    if (!provider.loaded)
      return Center(
        child: LoadingIndicator(),
      );

    return CandiesRefreshList(
      onRefresh: () async {
        await provider.getActivities(refresh: true);
        return provider.loaded;
      },
      content: contentList(provider),
    );
  }

  Widget tryPayload(GitHub.Event event) {
    String result;
    if (event.type == "IssueCommentEvent") {
      IssueCommentEventPayload payload =
          IssueCommentEventPayload.fromJSON(event.payload);
      result = payload.action;
    } else {
      result = "No payload generated";
    }
    return Text(
      result,
      style: TextStyle(fontSize: suSetSp(22.0)),
    );
  }

  Widget _eventUser(context, GitHub.Event event) => Positioned(
        top: 0.0,
        left: 0.0,
        right: suSetWidth(20.0),
        height: suSetWidth(avatarSize + 4),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: suSetWidth((avatarSize + 4) / 2),
              height: suSetWidth(avatarSize + 4),
              child: UnconstrainedBox(
                child: Container(
                  padding: EdgeInsets.only(right: suSetWidth((avatarSize) / 2)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(avatarSize),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).dividerColor.withAlpha(20),
                        blurRadius: suSetWidth(5.0),
                        offset: Offset(0, 1),
                      )
                    ],
                    color: Theme.of(context).cardColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(suSetWidth(8.0)),
                    child: Text(
                      event.actor.name ?? event.actor.login,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: suSetSp(26.0),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              child: Container(
                width: suSetWidth(avatarSize + 4),
                height: suSetWidth(avatarSize + 4),
                padding: EdgeInsets.all(suSetWidth(2.0)),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).dividerColor.withAlpha(20),
                      blurRadius: suSetWidth(5.0),
                      offset: Offset(0, 1),
                    )
                  ],
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              height: suSetWidth(avatarSize + 4),
              child: Padding(
                padding: EdgeInsets.all(suSetWidth(2.0)),
                child: UserAvatar(
                  url: event.actor.avatarUrl,
                  size: avatarSize,
                ),
              ),
            ),
          ],
        ),
      );

  Widget event(context, GitHub.Event event) {
    return Container(
      margin: EdgeInsets.only(top: suSetHeight(10.0)),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(top: suSetWidth(avatarSize + 4) / 2),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(suSetWidth(16.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    tryPayload(event),
                    Text(
                      event.type,
                      style: TextStyle(
                        fontSize: suSetSp(22.0),
                      ),
                    ),
                    if (event.repo != null)
                      Text(
                        event.repo.name,
                        style: TextStyle(
                          fontSize: suSetSp(22.0),
                        ),
                      ),
                    Text(
                      Constants.timeHandler(event.createdAt),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _eventUser(context, event),
        ],
      ),
    );
  }

  Widget contentList(ActivitiesProvider provider) {
    final events = provider.activities;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final activities = provider.activities[index];
          return Padding(
            padding: EdgeInsets.all(suSetWidth(4.0)),
            child: event(context, activities),
          );
        },
        childCount: events.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesProvider>(
      builder: (context, provider, _) {
        return FutureBuilder(
          future: () async {
            await provider.getActivities();
            return provider.activities;
          }(),
          builder: (_, __) => events(provider),
        );
      },
    );
  }
}
