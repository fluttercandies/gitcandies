import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:github/server.dart';

import 'package:gitcandies/providers/providers.dart';

class ActivitiesProvider extends BaseProvider {
  ActivityService get service => github.activity;

  bool loaded = false, loading = true;
  List<Event> activities = [];

  Future getActivities({bool refresh = false, String username}) async {
    final userProvider = getProvider<UserProvider>();
    final isCurrentUser = username != null || username != userProvider
        .currentUser.login;
    Timer pollTimer;

    loading = true;
    debugPrint("Getting activities...");
    EventPoller eventPoller = service
        .pollEventsReceivedByUser(username ?? userProvider.currentUser.login);
    Stream<Event> stream =
        eventPoller.start(onlyNew: !(!loaded || refresh)).asBroadcastStream()
          ..listen((event) {
            if (isCurrentUser) activities.add(event);
            pollTimer?.cancel();
            pollTimer = Timer(Duration(seconds: 1), () async {
              if (loading) {
                await eventPoller?.stop();
                loading = false;
              }
              if (!loaded) {
                loaded = true;
                notifyListeners();
              }
            });
          });

    List<Event> events = await stream.toList();
    if (!isCurrentUser) return events;
  }
}
