import 'dart:convert' show json, utf8;

import 'package:http/http.dart' as http;

class HttpUtils {
  Future<String> post(
    String url,
    Map<String, String> headers,
    Map<String, dynamic> map,
  ) async {
    final body = json.encode(map);
    final response = await http.post(
      url,
      headers: headers,
      body: body,
      encoding: utf8,
    );

    return response.body;
  }
}
