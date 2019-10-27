import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github/server.dart' as GitHub;
import 'package:ff_annotation_route/ff_annotation_route.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/providers/providers.dart';

@FFRoute(
  name: "/userpage",
  routeName: "用户页",
  argumentNames: ["user"],
)
class UserPage extends StatefulWidget {
  final GitHub.User user;

  const UserPage({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ScrollController _controller = ScrollController();
  GitHub.User user;
  bool showTitle = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _controller
      ..removeListener(listener)
      ..addListener(listener);
    super.didChangeDependencies();
  }

  void listener() {
    double triggerHeight = suSetSp(150) + kToolbarHeight;
    if (_controller.offset >= triggerHeight && !showTitle) {
      setState(() {
        showTitle = true;
      });
    } else if (_controller.offset < triggerHeight && showTitle) {
      setState(() {
        showTitle = false;
      });
    }
  }

  Widget wBio(GitHub.CurrentUser user, TextStyle style) => Padding(
        padding: EdgeInsets.only(bottom: suSetSp(10.0)),
        child: Text(user.bio, style: style, maxLines: 1),
      );

  Widget wOrganizations(TextStyle style) => Consumer<OrganizationsProvider>(
        builder: (context, provider, _) {
          if (provider.organizations.isEmpty) return SizedBox();
          return SizedBox(
            height: suSetSp(40.0),
            child: Row(
              children: <Widget>[
                Text("Belongs: ", style: style),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.organizations.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: suSetSp(2.0),
                        ),
                        child: UserAvatar(
                          url: provider.organizations[index].avatarUrl,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget userInfo(context) {
    GitHub.User _user =
        this.widget.user ?? Provider.of<UserProvider>(context).currentUser;
    final theme = Theme.of(context).copyWith(
      iconTheme: Theme.of(context).primaryIconTheme,
      textTheme: Theme.of(context).primaryTextTheme,
    );
    final titleStyle = theme.textTheme.title.copyWith(
      fontSize: suSetSp(20.0),
      fontWeight: FontWeight.w600,
    );
    final bodyStyle = theme.textTheme.body1.copyWith(
      fontSize: suSetSp(14.0),
    );

    List<Widget> content = [
      if (_user.name != null)
        Text(
          _user.name,
          style: titleStyle,
          maxLines: 1,
        ),
      Text(
        _user.login,
        style: bodyStyle,
        maxLines: 1,
      ),
      if (_user.location != null)
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: ui.PlaceholderAlignment.middle,
                child: Icon(Icons.location_on, size: suSetSp(14.0)),
              ),
              TextSpan(
                text: " ${_user.location}",
              ),
            ],
            style: bodyStyle,
          ),
          maxLines: 1,
        ),
      if (_user.company != null)
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: ui.PlaceholderAlignment.middle,
                child: Icon(Icons.supervised_user_circle, size: suSetSp(14.0)),
              ),
              TextSpan(
                text: " ${_user.company}",
              ),
            ],
            style: bodyStyle,
          ),
          maxLines: 1,
        ),
      if (_user.blog != null)
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: ui.PlaceholderAlignment.middle,
                child: Icon(Icons.link, size: suSetSp(14.0)),
              ),
              TextSpan(
                text: " ${_user.blog}",
              ),
            ],
            style: bodyStyle.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
          maxLines: 1,
        ),
    ];
    return SafeArea(
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).primaryIconTheme,
        ),
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.fromLTRB(
            suSetSp(16.0),
            suSetSp(16.0) + kToolbarHeight,
            suSetSp(16.0),
            suSetSp(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: suSetSp(10.0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UserAvatar(
                      size: 90.0,
                      url: _user.avatarUrl,
                    ),
                    SizedBox(width: suSetSp(16.0)),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (int i = 0; i < content.length; i++)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: suSetSp(6.0),
                              ),
                              child: content[i],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_user.bio != null) wBio(_user, bodyStyle),
              wOrganizations(bodyStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget wContribution(user) => Card(
        child: Padding(
          padding: EdgeInsets.all(suSetSp(8.0)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SvgPicture.network(
              API.graphicUrl(user.login),
              height: suSetSp(80.0),
            ),
          ),
        ),
      );

  Widget wTabs(GitHub.CurrentUser user) {
    final tabs = {
      "仓库": user.publicReposCount,
      "粉丝": user.followersCount,
      "关注": user.followingCount,
      "星标": 0,
    };
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        padding: EdgeInsets.all(suSetSp(6.0)),
        height: suSetSp(50.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor.withAlpha(100),
            ),
          ),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (int i = 0; i < 2 * tabs.length - 1; i++)
              i.isEven
                  ? Expanded(
                      child: Center(
                        child: Text(
                          tabs.keys.elementAt(i ~/ 2),
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Colors.white,
                                fontSize: suSetSp(14.0),
                              ),
                        ),
                      ),
                    )
                  : VerticalDivider(
                      color: Theme.of(context).dividerColor.withAlpha(200),
                    ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null)
      user = this.widget.user ?? Provider.of<UserProvider>(context).currentUser;
    final organizationsProvider = Provider.of<OrganizationsProvider>(context);
    if (!organizationsProvider.loaded)
      organizationsProvider.getOrganizations(refresh: true);
    return Material(
      child: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (context, isScrolled) {
          return <Widget>[
            SliverAppBar(
              title: showTitle
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UserAvatar(url: user.avatarUrl),
                        SizedBox(width: suSetSp(6.0)),
                        Text(
                          user.name ?? user.login,
                          style: TextStyle(
                            fontSize: suSetSp(14.0),
                          ),
                        ),
                      ],
                    )
                  : null,
              flexibleSpace: FlexibleSpaceBar(
                background: userInfo(context),
              ),
              expandedHeight: kToolbarHeight +
                  (organizationsProvider.organizations.isEmpty ? 168 : 208) +
                  kToolbarHeight,
              bottom: wTabs(user),
              primary: true,
              centerTitle: true,
              pinned: true,
            ),
          ];
        },
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            wContribution(user),
          ],
        ),
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
