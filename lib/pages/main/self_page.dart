import 'package:flutter/material.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/providers/providers.dart';
import 'package:gitcandies/utils/route_util.dart';

class SelfPage extends StatefulWidget {
  final PageController controller;

  const SelfPage({Key key, this.controller}) : super(key: key);

  @override
  _SelfPageState createState() => _SelfPageState();
}

class _SelfPageState extends State<SelfPage> {
  final List<List<Map<String, dynamic>>> settings = [
    [
      {
        "name": "Themes",
        "icon": Icons.color_lens,
        "action": () {
          showThemeDialog();
        },
      }
    ],
  ];

  void animateToMainPage() {
    widget.controller?.animateToPage(
      1,
      duration: kTabScrollDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget get actions => Padding(
        padding: EdgeInsets.symmetric(horizontal: suSetWidth(8.0)),
        child: SizedBox.fromSize(
          size: Size.fromHeight(kToolbarHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.exit_to_app),
                onPressed: Provider.of<LoginProvider>(context).logout,
                iconSize: suSetWidth(42.0),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.clear),
                onPressed: animateToMainPage,
                iconSize: suSetWidth(42.0),
              ),
            ],
          ),
        ),
      );

  Widget get userInfo => Consumer<UserProvider>(
        builder: (context, provider, _) {
          final user = provider.currentUser;
          return GestureDetector(
            onTap: () {
              RouteHelper().router.pushNamed("/userpage",
                  arguments: {"user": provider.currentUser});
            },
            child: Container(
              padding: EdgeInsets.all(suSetWidth(16.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  UserAvatar(
                    url: user.avatarUrl,
                    size: 100.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(suSetWidth(20.0)),
                    child: Text(
                      user.login,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: suSetSp(30.0),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget get setting => Expanded(
        child: Container(
          padding: EdgeInsets.all(suSetWidth(16.0)),
          child: ListView.builder(
            itemCount: settings.length,
            itemBuilder: (_, index) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < settings.length; i++) settingItem(index, i),
              ],
            ),
          ),
        ),
      );

  Widget settingItem(int sectionIndex, int index) {
    final item = settings[sectionIndex][index];
    return InkWell(
      onTap: item['action'],
      child: Padding(
        padding: EdgeInsets.all(suSetWidth(8.0)),
        child: Row(
          children: <Widget>[
            Icon(
              item['icon'],
              size: suSetWidth(42.0),
            ),
            SizedBox(width: suSetWidth(16.0)),
            Text(
              "${item['name']}",
              style: TextStyle(fontSize: suSetSp(30.0)),
            ),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_right,
              size: suSetWidth(42.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: Theme.of(context).primaryIconTheme,
        textTheme: Theme.of(context).primaryTextTheme,
      ),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              actions,
              userInfo,
              setting,
            ],
          ),
        ),
      ),
    );
  }
}
