import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';

class DiseaseService with ChangeNotifier {

  Future<List<Disease>> getAllDiseases() async {

    final dio = Dio();

    var uri = '${url}diseases';

    var response = await dio.get(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      List body = response.data["data"].map((e) => Disease.formJson(e)).toList();
      var data = body.cast<Disease>();
      return data;
    }

    return [];

  }

  Future<List<CatDiseaseDto>> getCatDiseases(CatViewModel cat) async {

    final dio = Dio();

    var uri = '${url}cats/${cat.catId}/diseases';

    var response = await dio.get(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      List body = response.data["data"].map((e) => CatDiseaseDto.fromJson(e)).toList();
      var data = body.cast<CatDiseaseDto>();
      return data;
    }

    return [];

  }

  Future<bool> registerCatDiseases(CatViewModel cat, int diseaseId) async{

    final dio = Dio();
    var uri = '${url}cat-diseases/cat/${cat.catId}/disease/$diseaseId';

    var response = await dio.post(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

}