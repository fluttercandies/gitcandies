import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:github/server.dart' as GitHub;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:gitav/constants/resource.dart';
import 'package:gitav/providers/notications_provider.dart';

class NotificationsPage extends StatelessWidget {
  final double _avatarSize = 30.0;

  String timeHandler(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference >= Duration(days: 365)) {
      return "on ${DateFormat("LLL dd yyyy").format(time)}";
    } else if (difference >= Duration(days: 30)) {
      return "on ${DateFormat("LLL d").format(time)}";
    } else if (difference >= Duration(days: 1)) {
      return "${difference.inDays} days ago";
    } else if (difference >= Duration(hours: 1)) {
      return "${difference.inHours} hours ago";
    } else if (difference >= Duration(minutes: 1)) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference >= Duration(seconds: 1)) {
      return "${difference.inSeconds} seconds ago";
    }
    return time.toString();
  }

  Widget avatar(String avatarUrl) => ClipRRect(
    borderRadius: BorderRadius.circular(_avatarSize),
    child: FadeInImage(
      fadeInDuration: const Duration(milliseconds: 100),
      placeholder: AssetImage(
        R.ASSETS_GITHUB_OCTOCAT_OCTOCAT_JPG,
      ),
      image: NetworkImage(avatarUrl),
      width: _avatarSize,
      height: _avatarSize,
      fit: BoxFit.cover,
    ),
  );

  Widget notification(
      context, GitHub.Repository repo, List<GitHub.Notification> ns) {
    return Card(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  avatar(repo.owner.avatarUrl),
                  SizedBox(width: 12.0),
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
            ),
            Divider(height: 1.0),
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (_, __) => Divider(height: 1.0),
              itemCount: ns.length,
              itemBuilder: (_, index) {
                final n = ns[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset("assets/octicon/${n.subject.type}.svg"),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(n.subject.title),
                            Text(
                              timeHandler(n.updatedAt),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget repoFields(NotificationsProvider provider) {
    if (!provider.loaded) return CircularProgressIndicator();

    Set<GitHub.Repository> repos = provider.repos;
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (_, __) => SizedBox(),
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = provider.notifications[repos.elementAt(index).fullName];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: notification(context, repos.elementAt(index), repo),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(R.ASSETS_GITHUB_LOGOS_LOGO_WHITE_PNG, height: 40.0),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            await provider.getNotifications(refresh: true, all: true);
          },
          child: FutureBuilder(
            future: provider.getNotifications(all: true),
            builder: (_, __) => repoFields(provider),
          ),
        ),
      ),
    );
  }
}
