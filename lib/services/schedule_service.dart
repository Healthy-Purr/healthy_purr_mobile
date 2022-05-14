import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthy_purr_mobile_app/models/dtos/schedule_meal_dto.dart';
import 'package:healthy_purr_mobile_app/models/entities/schedule.dart';

import '../models/entities/schedule_meal.dart';
import '../utils/constants/constants.dart';
import 'headers_service.dart';

class ScheduleService with ChangeNotifier {

  Future<List<Schedule>> getScheduleByUser(String id) async {

    final dio = Dio();

    var uri = '${url}cats/$id/schedules';

    var response = await dio.get(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      List body = response.data["data"].map((e) => Schedule.fromJson(e)).toList();
      var data = body.cast<Schedule>();
      return data;
    }

    return [];
  }

  Future<List<ScheduleMeal>> getScheduleMeal(String id) async {

    final dio = Dio();

    var uri = '${url}schedules/$id/meals';

    var response = await dio.get(uri, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      List body = response.data["data"].map((e) => ScheduleMeal.fromJson(e)).toList();
      var data = body.cast<ScheduleMeal>();
      return data;
    }

    return [];
  }

  Future<int> registerSchedule(int catId, DateTime dateTime) async {

    final dio = Dio();

    var _toSend = {
      'catId' : catId,
      'day' : dateTime.toString().substring(0, 10)
    };

    var uri = '${url}schedules';

    var response = await dio.post(uri, data: json.encode(_toSend), options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      int result = response.data["data"]["scheduleId"];
      return result;
    }

    return 0;
  }


  Future<int> registerMeal(int scheduleId, ScheduleMeal mealToRegister) async {

    final dio = Dio();

    var body = jsonEncode({
      'hour': mealToRegister.hour,
      'scheduleId': scheduleId,
      'isDry': mealToRegister.isDry,
      'isDamp': mealToRegister.isDamp,
      'hasMedicine': mealToRegister.hasMedicine,
      'description': ''
    });

    var uri = '${url}meals';

    var response = await dio.post(uri, data: body, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      int result = response.data["data"]["mealId"];
      return result;
    }

    return 0;
  }

  Future<bool> updateMeal(ScheduleMeal mealToRegister) async {

    final dio = Dio();

    var body = jsonEncode({
      'hour': mealToRegister.hour,
      'scheduleId': mealToRegister.scheduleId,
      'isDry': mealToRegister.isDry,
      'isDamp': mealToRegister.isDamp,
      'hasMedicine': mealToRegister.hasMedicine,
      'description': ''
    });

    var uri = '${url}meals/${mealToRegister.mealId}';

    var response = await dio.put(uri, data: body, options: Options(
        headers: HeadersService().getHeaders()
    ));

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

}