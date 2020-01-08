import 'package:flutter/material.dart';
import 'package:gitcandies/pages/activites_page.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/pages/notifications_page.dart';

class MainContentPage extends StatefulWidget {
  final PageController controller;

  const MainContentPage({Key key, this.controller}) : super(key: key);

  @override
  _MainContentPageState createState() => _MainContentPageState();
}

class _MainContentPageState extends State<MainContentPage>
    with AutomaticKeepAliveClientMixin {
  final pages = [
    {
      "name": "Events",
      "icon": Icons.event,
      "page": ActivitiesPage(),
    },
    {
      "name": "Notifications",
      "icon": Icons.notifications,
      "page": NotificationsPage(),
    },
    {
      "name": "Test",
      "icon": Icons.add,
      "page": SizedBox.shrink(),
    },
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
        title: Image.asset(
          R.ASSETS_CANDIES_LOGO_LOGO_WHITE_PNG,
          height: suSetHeight(kToolbarHeight),
        ),
        centerTitle: true,
        leading: Consumer<UserProvider>(
          builder: (context, provider, _) => UserAvatar(
            size: 52.0,
            url: provider.currentUser.avatarUrl,
            onTap: animateToSelfPage,
          ),
        ),
      ),
      body: IndexedStack(
        children: pages.map<Widget>((page) => page['page']).toList(),
        index: _tabIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: suSetWidth(36.0),
        selectedFontSize: suSetSp(24.0),
        unselectedFontSize: suSetSp(20.0),
        items: <BottomNavigationBarItem>[
          for (int i = 0; i < pages.length; i++)
            BottomNavigationBarItem(
              icon: Icon(pages[i]['icon']),
              title: Text(pages[i]['name']),
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
