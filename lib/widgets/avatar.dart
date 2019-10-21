import 'package:flutter/material.dart';

import 'package:gitcandies/constants/resource.dart';


class UserAvatar extends StatelessWidget {
  final String url;
  final double size;
  final GestureTapCallback onTap;

  const UserAvatar({
    Key key,
    @required this.url,
    this.size = 30.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: GestureDetector(
          onTap: onTap,
          child: FadeInImage(
            fadeInDuration: const Duration(milliseconds: 100),
            placeholder: AssetImage(
              R.ASSETS_GITHUB_OCTOCAT_OCTOCAT_JPG,
            ),
            image: NetworkImage(url),
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
