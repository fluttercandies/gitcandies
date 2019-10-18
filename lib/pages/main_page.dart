import 'package:flutter/material.dart';
import 'package:gitav/providers/user_provider.dart';
import 'package:provider/provider.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Provider.of<UserProvider>(context).currentUser.name,
            ),
          ],
        ),
      ),
    );
  }
}
