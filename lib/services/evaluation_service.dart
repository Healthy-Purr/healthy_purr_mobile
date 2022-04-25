import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

import '../models/entities/cat_food_analysis.dart';

class EvaluationService{

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


}