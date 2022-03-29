import 'dart:convert';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import '../models/model.dart';
import '../utils/util.dart';
import 'dart:io';
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

  Future<bool> uploadCatImage(File file, CatViewModel cat) async {
    bool resp = false;

    var uri = Uri.parse('${url}cats/${cat.catId}/picture');

    var request = http.MultipartRequest("PUT", uri);

    request.headers.addAll(HeadersService().getHeaders());

    var stream = http.ByteStream(DelegatingStream(file.openRead()));

    var length = await file.length();

    var multipartFile = http.MultipartFile('file', stream, length, filename: file.path.split('/').last);

    request.files.add(multipartFile);

    await request.send().then((value){
      if(value.statusCode == 200){
        resp = true;
      }
    });

    return resp;
  }

  Future<void> createCat(CatRegisterDto catDto, int userId) async {
    final dio = Dio();

    var uri = '${url}users/$userId/cats';

    var body = jsonEncode({
      'name': catDto.name,
      'weight': catDto.weight,
      'age': catDto.age,
      'gender': catDto.gender,
      'hasDisease': catDto.hasDisease,
      'isAllergic': catDto.isAllergic
    });

    await dio.post(uri, data: body, options: Options(
      headers: HeadersService().getHeaders()
    ));

    //TODO: SHOW NOTIFICATION

  }

  Future<void> updateCat(CatRegisterDto catDto, int catId) async {
    final dio = Dio();

    var uri = '${url}cats/$catId';

    var body = jsonEncode({
      'name': catDto.name,
      'weight': catDto.weight,
      'age': catDto.age,
      'gender': catDto.gender,
      'hasDisease': catDto.hasDisease,
      'isAllergic': catDto.isAllergic
    });

    await dio.put(uri, data: body, options:  Options(
        headers: HeadersService().getHeaders()
    ));

    //TODO: SHOW NOTIFICATION

  }

  Future<bool> deleteCat(CatViewModel cat) async {
    final dio = Dio();

    var uri = '${url}cats/${cat.catId}/delete';

    Response<String> response = await dio.put(uri, options: Options(
        headers: HeadersService().getHeaders()));

    if(response.statusCode == 200 && response.data!.contains('deleted')) {
      return true;
    } else {
      return false;
    }
  }

}