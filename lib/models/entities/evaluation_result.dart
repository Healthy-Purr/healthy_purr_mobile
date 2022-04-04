class EvaluationResult {
  final int? evaluationResultId;
  final int? userId;
  final int? catId;
  final int? evaluatedFoodId;
  final String? description;
  final double? accuracyRate;
  final DateTime? createdAt;
  final String? location;

  EvaluationResult({
    this.evaluationResultId,
    this.userId,
    this.catId,
    this.evaluatedFoodId,
    this.description,
    this.accuracyRate,
    this.createdAt,
    this.location,
  });

  factory EvaluationResult.fromJson(Map<String, dynamic> evaluationResult) {
    return EvaluationResult(
        evaluationResultId: evaluationResult['evaluationResultId'],
        userId: evaluationResult['userId'],
        catId: evaluationResult['catId'],
        evaluatedFoodId: evaluationResult['evaluatedFoodId'],
        description: evaluationResult['description'],
        accuracyRate: evaluationResult['accuracyRate'],
        createdAt: DateTime.parse(evaluationResult['createdAt']),
        location: evaluationResult['location']
    );
  }

}