class Schedule {
  final int? scheduleId;
  final int? catId;
  final bool? status;
  final DateTime? day;
  final String? createdAt;

  Schedule({
    this.createdAt,
    this.scheduleId,
    this.catId,
    this.status,
    this.day
  });

  Schedule.fromSchedule(this.scheduleId, this.catId, this.status, this.day, this.createdAt);


  factory Schedule.fromJson(Map<String, dynamic> scheduleJson) {
    return Schedule(
        createdAt: scheduleJson['createdAt'],
        scheduleId: scheduleJson['scheduleId'],
        catId: scheduleJson['catId'],
        status: scheduleJson['status'],
        day: DateTime.parse(scheduleJson['day']) 
    );
  }

}