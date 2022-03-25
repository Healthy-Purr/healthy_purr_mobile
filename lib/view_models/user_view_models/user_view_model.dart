import 'dart:convert';

import 'package:healthy_purr_mobile_app/utils/util.dart';
import '../../models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';

import 'package:http/http.dart' as http;

class UserViewModel {

  //late final User user;

  // int? get userId => user.userId;
  //
  // String? get name =>user.name;
  //
  // String? get lastName => user.lastName;
  //
  // String? get email => user.email;

  // Future<void> setUserInformation() async {
  //
  //   String userId = await UserService().getUserIdFromSharedPreferences();
  //
  //   var uri = Uri.parse('${url}users/$userId/simple');
  //   var headers =  await HeadersService().getHeaders();
  //   var response = await http.get(uri, headers: headers);
  //
  //   if(response.statusCode == 200) {
  //     var body = jsonDecode(response.body);
  //     var dataJson = body["data"];
  //     user = User.fromJson(dataJson);
  //   }
  // }

}