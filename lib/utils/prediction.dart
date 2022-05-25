
import 'package:healthy_purr_mobile_app/models/dtos/evaluation_dto.dart';
import 'package:healthy_purr_mobile_app/models/entities/cat_food_analysis.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

Future<double> calculateFoodAffinity(
    double weight,
    double age,
    double sex,
    double obesity,
    double diabetes,
    double cardiac,
    double diarrhea,
    double cystitis,
    double kidneyStones,
    double malNutrition,
    double eggAllergy,
    double meatAllergy,
    double pigAllergy,
    double milkAllergy,
    double soyAllergy,
    double fishAllergy,
    double cheeseAllergy,
    double chickenAllergy,
    CatFoodAnalysis catFoodAnalysis,
    ) async {
  final interpreter = await Interpreter.fromAsset('ia_model/converted_model.tflite');

  final double isDry = catFoodAnalysis.analysis!.moisture! < 0.65 ? 1.0 : 0.0;

  double? result;

  var input = [
    [weight, age, sex, obesity, diabetes, cardiac, diarrhea, cystitis, kidneyStones, malNutrition, eggAllergy, catFoodAnalysis.ingredients!.egg, meatAllergy, catFoodAnalysis.ingredients!.meat, pigAllergy, catFoodAnalysis.ingredients!.pig,
      milkAllergy, catFoodAnalysis.ingredients!.milk, soyAllergy, catFoodAnalysis.ingredients!.soy, fishAllergy, catFoodAnalysis.ingredients!.fish, cheeseAllergy, catFoodAnalysis.ingredients!.cheese,
      chickenAllergy, catFoodAnalysis.ingredients!.chicken, isDry, catFoodAnalysis.analysis!.protein, catFoodAnalysis.analysis!.fat, catFoodAnalysis.analysis!.fiber, catFoodAnalysis.analysis!.moisture,
      catFoodAnalysis.analysis!.calcium, catFoodAnalysis.analysis!.phosphorus, catFoodAnalysis.analysis!.ash, catFoodAnalysis.analysis!.carbohydrates, catFoodAnalysis.taurine!.taurine,
      catFoodAnalysis.ingredients!.colorant]
  ];

  var output = List.filled(1, 0).reshape([1, 1]);

  interpreter.run(input, output);

   result = output[0][0];

  if(result != null && result > 1){
    result = 1;
  }

  interpreter.close();

  return result ?? -1;

}