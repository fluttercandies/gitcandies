import 'package:flutter/material.dart';
import 'package:github/server.dart' as GitHub;

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/providers/providers.dart';

class ActivitiesPage extends StatelessWidget {
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
    return Text(result);
  }

  Widget event(context, GitHub.Event event) {
    final avatarSize = 50.0;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(top: avatarSize / 2),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
//                    tryPayload(event),
                    Text(
                      event.type,
                    ),
                    if (event.repo != null)
                      Text(
                        event.repo.name,
                      ),
                    Text(
                      Constants.timeHandler(event.createdAt),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 10.0,
            height: avatarSize + 4,
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: (avatarSize + 4) / 2,
                  height: avatarSize + 4,
                  child: UnconstrainedBox(
                    child: Container(
                      padding: EdgeInsets.only(right: (avatarSize + 4) / 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(avatarSize),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .backgroundColor
                                .withAlpha(100),
                            blurRadius: 5.0,
                            offset: Offset(0, 1),
                          )
                        ],
                        color: Theme.of(context).cardColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          event.actor.name ?? event.actor.login,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0.0,
                  child: Container(
                    width: avatarSize + 4,
                    height: avatarSize + 4,
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).backgroundColor.withAlpha(100),
                          blurRadius: 5.0,
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
                  height: avatarSize + 4,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: UserAvatar(
                      url: event.actor.avatarUrl,
                      size: avatarSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            padding: const EdgeInsets.all(4.0),
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
          future: provider.getActivities(),
          builder: (_, __) => events(provider),
        );
      },
    );
  }
}
