class EvaluationResultDto {
  int? userId;
  int? catId;
  int? evaluatedFoodId;
  String? description;
  double? accuracyRate;
  String? location;

  EvaluationResultDto({
    this.userId,
    this.catId,
    this.evaluatedFoodId,
    this.description,
    this.accuracyRate,
    this.location
  });

  Map toJson() => {
    'userId' : userId,
    'catId' : catId,
    'evaluatedFoodId': evaluatedFoodId,
    'description' : description,
    'accuracyRate' : accuracyRate,
    'location' : location
  };

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

  Map toJson() => {
    'protein' : protein,
    'fat' : fat,
    'fiber' : fiber,
    'moisture' : moisture,
    'calcium' : calcium,
    'phosphorus' : phosphorus,
    'hasTaurine' : hasTaurine
  };
}