class ScheduleMealDto{

  String? hour;
  String? description;
  bool? isDry;
  bool? isDamp;
  bool? hasMedicine;
  int? scheduleId;

  ScheduleMealDto(
  {this.hour,
    this.description,
    this.isDry,
    this.isDamp,
    this.hasMedicine,
    this.scheduleId});

  ScheduleMealDto.fromScheduleMealDto(String _hour, String _description, bool _isDry, bool _isDamp, bool _hasMedicine, int _scheduleId){
    hour = _hour;
    description = _description;
    isDry = _isDry;
    isDamp = _isDamp;
    hasMedicine = _hasMedicine;
    scheduleId = _scheduleId;
  }

  factory ScheduleMealDto.fromJson(Map<String, dynamic> scheduleMealDto) {
    return ScheduleMealDto(
      hour: scheduleMealDto['hour'],
      description: scheduleMealDto['description'],
      isDry: scheduleMealDto['isDry'],
      isDamp: scheduleMealDto['isDamp'],
      hasMedicine: scheduleMealDto['hasMedicine'],
      scheduleId: scheduleMealDto['scheduleId'],
    );
  }

}