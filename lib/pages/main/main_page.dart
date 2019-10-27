import 'package:flutter/material.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

import 'package:gitcandies/pages/main/main_content_page.dart';
import 'package:gitcandies/pages/main/self_page.dart';

@FFRoute(name: "/mainpage", routeName: "首页")
class MainPage extends StatelessWidget {
  final PageController _controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const ClampingScrollPhysics(),
      controller: _controller,
      children: <Widget>[
        SelfPage(controller: _controller),
        MainContentPage(controller: _controller),
      ],
    );
  }
}
