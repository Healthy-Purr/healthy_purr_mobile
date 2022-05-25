class EvaluatedFood {
  final int? evaluatedFoodId;
  final double? protein;
  final double? fat;
  final double? fiber;
  final double? moisture;
  final double? calcium;
  final double? phosphorus;
  final bool? hasTaurine;

  EvaluatedFood({
    this.evaluatedFoodId,
    this.protein,
    this.fat,
    this.fiber,
    this.moisture,
    this.calcium,
    this.phosphorus,
    this.hasTaurine,
  });

  factory EvaluatedFood.fromJson(Map<String, dynamic> evaluatedFood) {
    return EvaluatedFood(
      evaluatedFoodId: evaluatedFood['evaluatedFoodId'],
      protein: evaluatedFood['protein'],
      fat: evaluatedFood['fat'],
      fiber: evaluatedFood['fiber'],
      moisture: evaluatedFood['moisture'],
      calcium: evaluatedFood['calcium'],
      phosphorus: evaluatedFood['phosphorus'],
      hasTaurine: evaluatedFood['hasTaurine']
    );
  }

}