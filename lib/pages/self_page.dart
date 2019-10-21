import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gitcandies/providers/login_provider.dart';
import 'package:gitcandies/providers/user_provider.dart';
import 'package:gitcandies/widgets/avatar.dart';


class SelfPage extends StatefulWidget {
  final PageController controller;

  const SelfPage({Key key, this.controller}) : super(key: key);

  @override
  _SelfPageState createState() => _SelfPageState();
}

class _SelfPageState extends State<SelfPage> {
  void animateToMainPage() {
    widget.controller?.animateToPage(
      1,
      duration: kTabScrollDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget get actions => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: IconTheme(
      data: Theme.of(context).iconTheme.copyWith(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: Provider.of<LoginProvider>(context).logout,
            iconSize: 30.0,
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: animateToMainPage,
            iconSize: 30.0,
          ),
        ],
      ),
    ),
  );

  Widget get userInfo => Container(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Consumer<UserProvider>(
          builder: (context, provider, _) => UserAvatar(
            url: provider.currentUser.avatarUrl,
            size: 100.0,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            actions,
            userInfo,
          ],
        ),
      ),
    );
  }
}
