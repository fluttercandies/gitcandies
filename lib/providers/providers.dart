import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:gitcandies/providers/login_provider.dart';
import 'package:gitcandies/providers/activities_provider.dart';
import 'package:gitcandies/providers/notications_provider.dart';
import 'package:gitcandies/providers/organizations_provider.dart';
import 'package:gitcandies/providers/user_provider.dart';
import 'package:gitcandies/providers/themes_provider.dart';

export 'package:provider/provider.dart';
export 'package:gitcandies/providers/base_provider.dart';
export 'package:gitcandies/providers/login_provider.dart';
export 'package:gitcandies/providers/activities_provider.dart';
export 'package:gitcandies/providers/notications_provider.dart';
export 'package:gitcandies/providers/organizations_provider.dart';
export 'package:gitcandies/providers/user_provider.dart';
export 'package:gitcandies/providers/themes_provider.dart';

ChangeNotifierProvider<T> _buildProvider<T extends ChangeNotifier>(T value) {
  return ChangeNotifierProvider<T>.value(value: value);
}

List<SingleChildCloneableWidget> get providers => _providers;

final _providers = [
  _buildProvider<ThemesProvider>(ThemesProvider()),
  _buildProvider<LoginProvider>(LoginProvider()),
  _buildProvider<UserProvider>(UserProvider()),
  _buildProvider<ActivitiesProvider>(ActivitiesProvider()),
  _buildProvider<NotificationsProvider>(NotificationsProvider()),
  _buildProvider<OrganizationsProvider>(OrganizationsProvider()),
];
