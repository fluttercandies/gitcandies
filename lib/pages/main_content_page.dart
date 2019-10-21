import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gitcandies/constants/resource.dart';
import 'package:gitcandies/pages/notifications_page.dart';
import 'package:gitcandies/providers/login_provider.dart';
import 'package:gitcandies/providers/user_provider.dart';
import 'package:gitcandies/widgets/avatar.dart';

class MainContentPage extends StatefulWidget {
  final PageController controller;

  const MainContentPage({Key key, this.controller}) : super(key: key);

  @override
  _MainContentPageState createState() => _MainContentPageState();
}

class _MainContentPageState extends State<MainContentPage> with AutomaticKeepAliveClientMixin {
  final icons = [Icons.notifications, Icons.add, Icons.account_circle];
  final titles = ["Notifications", "测试1", "Mine"];

  List<Widget> pages = <Widget>[
    NotificationsPage(),
    SizedBox(),
    Center(
      child: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          return IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              provider.logout();
            },
          );
        },
      ),
    ),
  ];

  int _tabIndex = 0;

  @override
  bool get wantKeepAlive => true;

  void animateToSelfPage() {
    widget.controller?.animateToPage(
      0,
      duration: kTabScrollDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(R.ASSETS_GITHUB_LOGOS_LOGO_WHITE_PNG, height: 40.0),
        centerTitle: true,
        leading: Consumer<UserProvider>(
          builder: (context, provider, _) => UserAvatar(
            size: 36.0,
            url: provider.currentUser.avatarUrl,
            onTap: animateToSelfPage,
          ),
        ),
      ),
      body: IndexedStack(
        children: pages,
        index: _tabIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          for (int i = 0; i < titles.length; i++)
            BottomNavigationBarItem(
              icon: Icon(icons[i]),
              title: Text(titles[i]),
            ),
        ],
        currentIndex: _tabIndex,
        onTap: (int index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }
}
