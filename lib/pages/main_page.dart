import 'package:flutter/material.dart';
import 'package:gitav/pages/notifications_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final icons = [Icons.notifications, Icons.add, Icons.account_circle];
  final titles = ["Notifications", "测试1", "Mine"];
  final pages = <Widget>[
    NotificationsPage(),
    SizedBox(),
    SizedBox(),
  ];

  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            )
          ,
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
