import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:github/server.dart' as GitHub;
import 'package:provider/provider.dart';

import 'package:gitcandies/constants/screens.dart';
import 'package:gitcandies/providers/organizations_provider.dart';
import 'package:gitcandies/providers/user_provider.dart';
import 'package:gitcandies/widgets/avatar.dart';


class SelfPage extends StatefulWidget {
  final PageController controller;

  const SelfPage({Key key, @required this.controller}) : super(key: key);

  @override
  _SelfPageState createState() => _SelfPageState();
}

class _SelfPageState extends State<SelfPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void animateToMainPage() {
    widget.controller?.animateToPage(
      1,
      duration: kTabScrollDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget get clearButton => IconButton(
        alignment: Alignment.topRight,
        padding: EdgeInsets.zero,
        color: Colors.white,
        icon: Icon(Icons.clear),
        onPressed: animateToMainPage,
      );

  Widget userInfo(context, GitHub.CurrentUser user) {
    final titleStyle = Theme.of(context).textTheme.title.copyWith(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        );
    final bodyStyle = Theme.of(context).textTheme.body1.copyWith(
          color: Colors.white,
          fontSize: 14.0,
        );

    List<Widget> content = [
      if (user.name != null)
        Text(
          user.name,
          style: titleStyle,
        ),
      Text(
        user.login,
        style: bodyStyle,
      ),
      if (user.location != null)
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: ui.PlaceholderAlignment.middle,
                child: Icon(Icons.location_on, size: 14.0),
              ),
              TextSpan(
                text: " ${user.location}",
              ),
            ],
            style: bodyStyle,
          ),
        ),
      if (user.company != null)
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: ui.PlaceholderAlignment.middle,
                child: Icon(Icons.supervised_user_circle, size: 14.0),
              ),
              TextSpan(
                text: " ${user.company}",
              ),
            ],
            style: bodyStyle,
          ),
        ),
      if (user.blog != null)
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: ui.PlaceholderAlignment.middle,
                child: Icon(Icons.link, size: 14.0),
              ),
              TextSpan(
                text: " ${user.blog}",
              ),
            ],
            style: bodyStyle.copyWith(
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
    ];
    return Container(
      color: Theme.of(context).primaryColor,
      padding:
          EdgeInsets.fromLTRB(16.0, Screen.topSafeHeight + 16.0, 16.0, 16.0),
      child: IconTheme(
        data: IconThemeData(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserAvatar(
                    size: 90.0,
                    url: user.avatarUrl,
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (int i = 0; i < content.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: content[i],
                          ),
                      ],
                    ),
                  ),
                  clearButton,
                ],
              ),
            ),
            if (user.bio != null)
              Text(
                user.bio,
                style: bodyStyle,
              ),
            Consumer<OrganizationsProvider>(
              builder: (context, provider, _) {
                if (provider.organizations.isEmpty) {
                  return SizedBox();
                }
                return SizedBox(
                  height: 40.0,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Orgs: ",
                        style: bodyStyle,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.organizations.length,
                          itemBuilder: (context, index) {
                            return UserAvatar(
                              url: provider.organizations[index].avatarUrl,
                            );
                          },
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

  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    final organizationsProvider = Provider.of<OrganizationsProvider>(context);
    if (!organizationsProvider.loaded)
      organizationsProvider.getOrganizations(refresh: true);
    return Material(
      child: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverHeaderDelegate(
                minHeight: 250,
                maxHeight: 250,
                snapConfig: FloatingHeaderSnapConfiguration(
                  vsync: this,
                  curve: Curves.bounceInOut,
                  duration: Duration.zero,
                ),
                builder: (BuildContext context, double shrinkOffset,
                    bool overlapsContent) {
                  return Transform.translate(
                    offset: Offset(0, -shrinkOffset),
                    child: SizedBox.expand(
                      child: userInfo(context, user),
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: Container(),
      ),
    );
  }
}


class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.snapConfig,
    this.child,
    this.builder,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;
  final Builder builder;
  final FloatingHeaderSnapConfiguration snapConfig;
  AnimationController animationController;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (builder != null) {
      return builder(context, shrinkOffset, overlapsContent);
    }
    return child;
  }

  @override
  bool shouldRebuild(SliverHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => snapConfig;
}

typedef Widget Builder(
    BuildContext context, double shrinkOffset, bool overlapsContent);
