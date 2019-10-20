import 'package:flutter/foundation.dart';
import 'package:github/server.dart';

import 'package:gitav/providers/base_provider.dart';

class NotificationsProvider extends BaseProvider {
  ActivityService get activities => github.activity;

  bool loaded = false;
  Map<String, List<Notification>> notifications = {};
  Set<Repository> repos = {};
  Future<void> getNotifications({bool refresh = false, bool all = false}) async {
    if (!loaded || refresh) {
      debugPrint("Getting notifications...");
      var ns = await activities.listNotifications(all: all).toList();
      if (refresh) {
        repos.clear();
        notifications.clear();
      }
      ns.forEach((n) {
        final repo = n.repository;
        if (!repos.any((r) => r.fullName == repo.fullName)) {
          repos.add(repo);
          notifications[repo.fullName] = [];
        }
        notifications[repo.fullName].add(n);
      });
      loaded = true;
      notifyListeners();
    } else {
      debugPrint("Notifications loaded.");
    }
  }
}