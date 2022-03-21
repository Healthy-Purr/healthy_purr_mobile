import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import '../models/model.dart';
import '../utils/util.dart';

import 'package:http/http.dart' as http;

class CatService with ChangeNotifier {

  Future<List<Cat>> getCatsByUserId(String id) async {

    final dio = Dio();

    var uri = '${url}users/$id/cats';


    var response = await dio.get(uri, options: Options(
      headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      List body = response.data["data"].map((e) => Cat.fromJson(e)).toList();
      var data = body.cast<Cat>();
      return data;
    }

    return [];
  }

  Future<NetworkImage> getCatImage(CatViewModel cat) async {
    var uri = Uri.parse('${url}cats/${cat.catId}/picture');
    return NetworkImage(uri.toString(), headers: HeadersService().getHeaders());
  }

}