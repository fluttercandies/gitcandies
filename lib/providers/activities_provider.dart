import 'package:flutter/foundation.dart';
import 'package:github/server.dart';

import 'package:gitcandies/providers/base_provider.dart';
import 'package:gitcandies/providers/user_provider.dart';


class ActivitiesProvider extends BaseProvider {
  ActivityService get service => github.activity;

  bool loaded = false;
  List<Event> activities = [];
  Future<void> getActivities({bool refresh = false}) async {
    if (!loaded || refresh) {
      debugPrint("Getting activities...");
      final userProvider = getProvider<UserProvider>();
      service.pollEventsReceivedByUser(userProvider
          .currentUser.login).start().listen((event) {
        activities.add(event);
      }).onDone(() {
        loaded = true;
        notifyListeners();
      });
    } else {
      debugPrint("Activities loaded.");
    }
  }
}