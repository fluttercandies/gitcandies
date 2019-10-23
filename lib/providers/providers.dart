import 'package:flutter/foundation.dart';
import 'package:gitcandies/providers/themes_provider.dart';
import 'package:provider/provider.dart';

import 'package:gitcandies/providers/login_provider.dart';
import 'package:gitcandies/providers/activities_provider.dart';
import 'package:gitcandies/providers/notications_provider.dart';
import 'package:gitcandies/providers/organizations_provider.dart';
import 'package:gitcandies/providers/user_provider.dart';


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
