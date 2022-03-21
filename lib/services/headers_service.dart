import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';

class HeadersService with ChangeNotifier {

  late var _headers;

  dynamic getHeaders() {
    return _headers;
  }

  Future<void> setHeaders() async {

    String userToken = await UserService().getUserTokenFromSharedPreferences();

    var headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $userToken"
    };

    _headers = headers;

  }

}