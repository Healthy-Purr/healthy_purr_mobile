import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/model.dart';
import '../utils/util.dart';

import 'package:http/http.dart' as http;


class UserService with ChangeNotifier {

  var headers = {
    "Accept": "application/json",
    "content-type": "application/json"
  };

  Future<void> registerUser(UserRegisterDto user, BuildContext context) async {
    var uri = Uri.parse('${url}users');

    var body = jsonEncode({
      'name': user.name,
      'lastName': user.lastName,
      'username': user.email,
      'password': user.password.toString(),
      'birthDate': DateTime.now().toString(),
    });

    await http.post(uri, body: body, headers: headers);
  }

  Future<bool> loginUser(UserLoginDto user, BuildContext context) async {
    var uri =url + "auth";

    final dio = Dio();

    var body = jsonEncode({
      'username': user.email,
      'password': user.password
    });

    var response = await dio.post(uri, data: body);

    if (response.statusCode == 200) {
      UserSession()
        ..id = response.data["user"]["userId"]
        ..name = response.data["user"]["name"]
        ..lastName = response.data["user"]["lastName"]
        ..userName = response.data["user"]["username"]
        ..token = response.data["jwt"];
      return true;
    } else {
      return false;
    }
  }

}