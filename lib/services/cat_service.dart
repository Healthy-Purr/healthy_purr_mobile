import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import '../models/model.dart';
import '../utils/util.dart';

import 'package:http/http.dart' as http;

class CatService with ChangeNotifier {

  Future<List<Cat>> getCatsByUserId(String id) async {

    var uri = Uri.parse('${url}users/$id/cats');
    var response = await http.get(uri, headers: HeadersService().getHeaders());

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var dataJson = body["data"] as List;
      var data = dataJson.map((e) => Cat.fromJson(e)).toList();
      return data;
    }

    return [];
  }

  Future<ImageProvider> getCatImage(CatViewModel cat) async {
    var uri = Uri.parse('${url}cats/${cat.catId}/picture');
    return NetworkImage(uri.toString(), headers: HeadersService().getHeaders());
  }

}