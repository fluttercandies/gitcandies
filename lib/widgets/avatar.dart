import 'package:flutter/material.dart';

import 'package:gitcandies/constants/constants.dart';

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
              R.ASSETS_CANDIES_FLUTTER_CANDIES_PNG,
            ),
            image: NetworkImage(url),
            width: suSetSp(size),
            height: suSetSp(size),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
