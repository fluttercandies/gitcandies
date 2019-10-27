import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:github/server.dart' as GitHub;

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/providers/providers.dart';

class NotificationsPage extends StatelessWidget {
  Widget _repoName(GitHub.Repository repo) {
    return Padding(
      padding: EdgeInsets.all(suSetSp(10.0)),
      child: Row(
        children: <Widget>[
          UserAvatar(
            url: repo.owner.avatarUrl,
          ),
          SizedBox(width: suSetSp(12.0)),
          Expanded(
            child: Text(
              repo.fullName,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notification(context, GitHub.Notification notification) {
    return Padding(
      padding: EdgeInsets.all(suSetSp(8.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(suSetSp(8.0)),
            child: SvgPicture.asset(
                "assets/octicon/${notification.subject.type}.svg",
              width: suSetSp(16.0),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  notification.subject.title,
                  style: TextStyle(
                    fontSize: suSetSp(16.0),
                  ),
                ),
                SizedBox(height: suSetSp(4.0)),
                Text(
                  Constants.timeHandler(notification.updatedAt),
                  style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: suSetSp(12.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _repo(context, GitHub.Repository repo, List<GitHub.Notification> ns) {
    return Card(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _repoName(repo),
            Divider(height: suSetSp(2.0)),
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (_, __) => Divider(height: suSetSp(2.0)),
              itemCount: ns.length,
              itemBuilder: (_, index) => _notification(context, ns[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget repoFields(NotificationsProvider provider) {
    if (!provider.loaded)
      return Center(
        child: LoadingIndicator(),
      );

    return CandiesRefreshList(
      onRefresh: () async {
        await provider.getNotifications(refresh: true, all: true);
        return provider.loaded;
      },
      content: contentList(provider),
    );
  }

  Widget contentList(NotificationsProvider provider) {
    final repos = provider.repos;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final repo = provider.notifications[repos.elementAt(index).fullName];
          return Padding(
            padding: EdgeInsets.all(suSetSp(4.0)),
            child: _repo(context, repos.elementAt(index), repo),
          );
        },
        childCount: repos.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, provider, _) {
        return FutureBuilder(
          future: provider.getNotifications(all: true),
          builder: (_, __) => repoFields(provider),
        );
      },
    );
  }
}
