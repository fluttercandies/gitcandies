import 'package:flutter/foundation.dart';
import 'package:github/server.dart';

import 'package:gitcandies/providers/providers.dart';

class OrganizationsProvider extends BaseProvider {
  OrganizationsService get _organizations => github.organizations;

  bool loaded = false;
  List<Organization> organizations = [];
  Future<void> getOrganizations({bool refresh = false, int page}) async {
    if (!loaded || refresh) {
      debugPrint("Getting organizations...");
      var os = await _organizations.list().toList();
      if (refresh) {
        organizations.clear();
      }
      organizations.addAll(os);
      loaded = true;
      notifyListeners();
    } else {
      debugPrint("Organizations loaded.");
    }
  }
}
