class ScheduleMeal{

  int? mealId;
  String? description;
  String? hour;
  bool? isDry;
  bool? isDamp;
  bool? hasMedicine;
  int? scheduleId;
  bool? status;

  ScheduleMeal({this.mealId, this.description, this.hour, this.isDry, this.isDamp, this.hasMedicine, this.scheduleId, this.status});

  ScheduleMeal.fromScheduleMeal(this.mealId, this.description, this.hour, this.isDry, this.isDamp, this.hasMedicine, this.scheduleId, this.status);

  factory ScheduleMeal.fromJson(Map<String, dynamic> scheduleMealDto) {
    return ScheduleMeal(
      mealId: scheduleMealDto['mealId'],
      hour: scheduleMealDto['hour'],
      description: scheduleMealDto['description'],
      isDry: scheduleMealDto['isDry'],
      isDamp: scheduleMealDto['isDamp'],
      hasMedicine: scheduleMealDto['hasMedicine'],
      scheduleId: scheduleMealDto['scheduleId'],
    );
  }

}