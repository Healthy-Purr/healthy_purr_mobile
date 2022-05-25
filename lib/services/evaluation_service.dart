import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluated_food.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluation_result.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

import '../models/dtos/evaluation_dto.dart';
import '../models/entities/cat_food_analysis.dart';

import 'package:http/http.dart' as http;

import 'headers_service.dart';

class EvaluationService{


  Future<bool> uploadEvaluationImage(File file, int erId) async {
    MultipartFile fileToSend = await MultipartFile.fromFile(file.path);

    var formData = FormData.fromMap({
      'file': fileToSend
    });

    var response = await Dio().put('${url}evaluations-result/$erId/picture', data: formData, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if(response.statusCode == 200){
      return true;
    }

    return false;
  }

  Future<int> registerEvaluationResult(EvaluationResultDto erDto) async {
    final dio = Dio();

    var uri = '${url}evaluations-result';

    var response = await dio.post(uri, data: erDto.toJson(), options: Options(
        headers: HeadersService().getHeaders()
    ));

    if(response.statusCode == 200){
      return response.data['data']['evaluationResultId'];
    }

    return -1;
  }

  Future<int> registerEvaluatedFood(EvaluatedFoodDto efDto) async {
    final dio = Dio();

    var uri = '${url}evaluated-foods';

    var response = await dio.post(uri, data: efDto.toJson(), options: Options(
        headers: HeadersService().getHeaders()
    ));

    if(response.statusCode == 200){
      return response.data['data']['evaluatedFoodId'];
    }

    return -1;

  }


  Future<CatFoodAnalysis> getFoodEvaluation(String text) async {

    final dio = Dio();

    var uri = evaluationUrl;

    var toSend = json.encode({
      'text' : text
    });

    var response = await dio.post(uri, data: toSend);

    if (response.statusCode == 200) {
      return CatFoodAnalysis.fromJson(response.data);
    }

    return CatFoodAnalysis();
  }


  Future<List<EvaluationResult>> getUserEvaluationResult() async{
    final dio = Dio();

    var uri = '${url}users/${UserSession().id}/evaluations-result';

    var response = await dio.get(uri, options: Options(
        headers: HeadersService().getHeaders()));

    if (response.statusCode == 200) {
      List body = response.data["data"].map((e) => EvaluationResult.fromJson(e)).toList();
      var data = body.cast<EvaluationResult>();
      return data;
    }

    return [];
  }

  Future<EvaluatedFood> getEvaluatedFood(int id) async{
    final dio = Dio();

    var uri = '${url}evaluated-foods/$id';

    var response = await dio.get(uri, options: Options(
        headers: HeadersService().getHeaders()));

    if (response.statusCode == 200) {
      return EvaluatedFood.fromJson(response.data["data"]);
    }

    return EvaluatedFood();
  }


  Future<NetworkImage> getEvaluationImage(int id) async {
    var uri = Uri.parse('${url}evaluations-result/$id/picture');
    return NetworkImage(uri.toString(), headers: HeadersService().getHeaders());
  }

}