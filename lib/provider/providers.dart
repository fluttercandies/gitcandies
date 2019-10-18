import 'package:flutter/foundation.dart';
import 'package:gitav/provider/login_provider.dart';
import 'package:provider/provider.dart';

ChangeNotifierProvider<T> _buildProvider<T extends ChangeNotifier>(T value) {
  return ChangeNotifierProvider<T>.value(value: value);
}

List<SingleChildCloneableWidget> get providers => _providers;

final _providers = [
  _buildProvider(LoginProvider()),
];
