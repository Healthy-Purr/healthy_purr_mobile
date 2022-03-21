import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    var uri = Uri.parse(url + "auth");
    var body = jsonEncode({
      'username': user.email,
      'password': user.password
    });
    var response = await http.post(uri, body: body, headers: headers);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', response.body);
      return true;
    } else {
      return false;
    }
  }

  Future<String> getUserIdFromSharedPreferences() async {

    //ACCESSING ID AS LIST
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefsResponse = prefs.getString('jwt').toString();

    //SPLIT ID
    List<String> firstSplit = prefsResponse.split(':');
    List<String> secondSplit = firstSplit[3].split('"');
    List<String> thirdSplit = secondSplit[0].split(',');

    //RETURNING ID
    String userId = thirdSplit[0];

    return userId;
  }

  Future<String> getUserTokenFromSharedPreferences() async {

    //ACCESSING ID AS LIST
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefsResponse = prefs.getString('jwt').toString();

    //SPLIT TOKEN
    List<String> firstSplit = prefsResponse.split(':');
    List<String> secondSplit = firstSplit[1].split('"');

    //RETURNING TOKEN
    String token = secondSplit[1];

    return token;
  }

}