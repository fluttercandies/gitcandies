import 'package:flutter/material.dart';

import 'package:gitcandies/providers/providers.dart';
import 'package:gitcandies/utils/utils.dart';

final Map<String, Color> themeColorMap = {
  'GitHub': Color(0xff25292d),
  'gray': Colors.grey,
  'cyan': Colors.cyan,
  'teal': Colors.teal,
  'green': Colors.green,
  'orange': Colors.orange,
  'deepOrange': Colors.deepOrange,
  'red': Colors.red,
  'pink': Colors.pink,
  'purple': Colors.purple,
  'indigo': Colors.indigo,
  'deepPurple': Colors.deepPurple,
  'deepPurpleAccent': Colors.deepPurpleAccent,
  'indigoAccent': Colors.indigoAccent,
  'blue': Colors.blue,
  'blueAccent': Colors.blueAccent,
};

void showThemeDialog() {
  RouteHelper().showDialog(
    Consumer<ThemesProvider>(
      builder: (context, provider, _) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: themeColorMap.keys.map((key) {
              Color value = themeColorMap[key];
              return InkWell(
                onTap: () async {
                  provider.setTheme(key);
                  await SpUtils.setTheme(provider.themeColor);
                },
                child: Container(
                  color: value,
                  child: provider.themeColor == key
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ),
  );
}
