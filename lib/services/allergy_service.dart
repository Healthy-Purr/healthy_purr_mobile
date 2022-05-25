import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';

class AllergyService with ChangeNotifier {

  Future<bool> deactivateAllergy(int catId, int allergyId) async {
    final dio = Dio();

    var uri = '${url}cat-allergics/cat/$catId/allergic/$allergyId/deactivate';

    var response = await dio.put(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }

  Future<List<Allergy>> getAllAllergies() async {

    final dio = Dio();

    var uri = '${url}allergics';

    var response = await dio.get(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      List body = response.data["data"].map((e) => Allergy.formJson(e)).toList();
      var data = body.cast<Allergy>();
      return data;
    }

    return [];

  }

  Future<List<CatAllergyDto>> getCatAllergies(CatViewModel cat) async {

    final dio = Dio();

    var uri = '${url}cats/${cat.catId}/allergics';

    var response = await dio.get(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      List body = response.data["data"].map((e) => CatAllergyDto.fromJson(e)).toList();
      var data = body.cast<CatAllergyDto>();
      return data;
    }

    return [];

  }

  Future<bool> registerCatAllergies(CatViewModel cat, int allergicId) async{

    final dio = Dio();
    var uri = '${url}cat-allergics/cat/${cat.catId}/allergic/$allergicId';

    var response = await dio.post(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

}