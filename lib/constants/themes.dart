import 'package:flutter/material.dart';
import 'package:gitcandies/providers/themes_provider.dart';
import 'package:gitcandies/utils/route_util.dart';
import 'package:provider/provider.dart';

final ThemeData gitcandiesTheme = ThemeData(
  primarySwatch: MaterialColor(4280625453, {
    50: Color(0xfff1f2f3),
    100: Color(0xffe3e6e8),
    200: Color(0xffc7ccd1),
    300: Color(0xffabb3ba),
    400: Color(0xff8f99a3),
    500: Color(0xff73808c),
    600: Color(0xff5c6670),
    700: Color(0xff454d54),
    800: Color(0xff2e3338),
    900: Color(0xff17191c)
  }),
);

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
    Material(
      type: MaterialType.transparency,
      child: Center(
        child: Consumer<ThemesProvider>(
          builder: (context, provider, _) => GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: themeColorMap.keys.map((key) {
              Color value = themeColorMap[key];
              return InkWell(
                onTap: () {
                  Provider.of<ThemesProvider>(context).setTheme(key);
                },
                child: Container(
                  color: value,
                  child: provider.themeColor == key ? Icon(
                    Icons.done,
                    color: Colors.white,
                  ) : null,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ),
  );
}