import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:github/server.dart';

import 'package:gitcandies/providers/providers.dart';

class ActivitiesProvider extends BaseProvider {
  ActivityService get service => github.activity;

  bool loaded = false, loading = true;
  List<Event> activities = [];
  EventPoller eventPoller;
  Timer pollTimer;

  void delayTimer(bool refresh) {
    pollTimer?.cancel();
    pollTimer = Timer(Duration(seconds: 1), () {
      donePoll(refresh);
    });
  }

  void donePoll(bool refresh) async {
    if (loading) {
      await eventPoller?.stop();
      loading = false;
    }
    if (!loaded) {
      loaded = true;
      notifyListeners();
    }
  }

  Future<void> getActivities({bool refresh = false}) async {
    if (!loaded || refresh) {
      loading = true;
      debugPrint("Getting activities...");
      final userProvider = getProvider<UserProvider>();
      eventPoller =
          service.pollEventsReceivedByUser(userProvider.currentUser.login);
      Stream<Event> stream =
          eventPoller.start(onlyNew: !(!loaded || refresh)).asBroadcastStream()
            ..listen((event) {
              activities.add(event);
              delayTimer(refresh);
            });
      await stream.toList();
    } else {
      debugPrint("Activities loaded.");
    }
  }
}
