class EvaluationDto {
  int? userId;
  int? catId;
  String? description;
  double? accuracyRate;
  String? location;

  EvaluationDto({
    this.userId,
    this.catId,
    this.description,
    this.accuracyRate,
    this.location
  });
}

class EvaluatedFoodDto {
  double? protein;
  double? fat;
  double? fiber;
  double? moisture;
  double? calcium;
  double? phosphorus;
  bool? hasTaurine;

  EvaluatedFoodDto({this.protein,
    this.fat,
    this.fiber,
    this.moisture,
    this.calcium,
    this.phosphorus,
    this.hasTaurine});
}