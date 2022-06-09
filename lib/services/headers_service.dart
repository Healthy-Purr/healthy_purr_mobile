import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/user_session.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';

class HeadersService with ChangeNotifier {

  getHeaders() {
    String userToken = UserSession().token!;

    return {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $userToken"
    };
  }

}