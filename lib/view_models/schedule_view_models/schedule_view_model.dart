

import 'package:healthy_purr_mobile_app/models/dtos/schedule_meal_dto.dart';

import '../../models/entities/schedule.dart';
import '../../models/entities/schedule_meal.dart';

class ScheduleViewModel {
  final Schedule schedule;

  List<ScheduleMeal> scheduleMealList;

  ScheduleViewModel({required this.schedule, required this.scheduleMealList});

  int? get scheduleId => schedule.scheduleId;

  DateTime? get day => schedule.day;

  bool? get status => schedule.status;

  int? get catId => schedule.catId;

  String? get createdAt => schedule.createdAt;

}