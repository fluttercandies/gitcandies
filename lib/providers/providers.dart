import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:gitav/providers/login_provider.dart';
import 'package:gitav/providers/notications_provider.dart';
import 'package:gitav/providers/user_provider.dart';


ChangeNotifierProvider<T> _buildProvider<T extends ChangeNotifier>(T value) {
  return ChangeNotifierProvider<T>.value(value: value);
}

List<SingleChildCloneableWidget> get providers => _providers;

final _providers = [
  _buildProvider<LoginProvider>(LoginProvider()),
  _buildProvider<UserProvider>(UserProvider()),
  _buildProvider<NotificationsProvider>(NotificationsProvider()),
];
