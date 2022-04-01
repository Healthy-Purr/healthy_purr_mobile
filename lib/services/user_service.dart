import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
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

  Future<void> updateUser(UserUpdateDto userDto, BuildContext context) async {
    final dio = Dio();

    var uri = '${url}users/${UserSession().id}';

    var body = jsonEncode({
      'name': userDto.name,
      'lastName': userDto.lastName,
      'username': userDto.userName,
      'password': userDto.password,
      'birthDate': userDto.birthDate
    });

    await dio.put(uri, data: body, options:  Options(
        headers: HeadersService().getHeaders()
    ));

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
        ..token = response.data["jwt"]
        ..password = response.data["user"]["password"]
        ..birthDate = response.data["user"]["birthDate"];
      return true;
    } else {
      return false;
    }
  }

  Future<ImageProvider> getUserImage(int userId) async {

    final dio = Dio();

    var uri = '${url}users/$userId/picture';

    Response<String> response = await dio.get(uri,
    options: Options(headers: HeadersService().getHeaders()));

    if(response.statusCode == 200 && !response.data!.contains('picture')) {
      return NetworkImage(uri.toString(), headers: HeadersService().getHeaders());
    } else {
      return const AssetImage('assets/images/user.png');
    }

  }

  Future<void> cleanUserSession() async {
    UserSession()
        ..id = 0
        ..name = ""
        ..lastName = ""
        ..userName = ""
        ..token = "";
  }

}