
import 'package:healthy_purr_mobile_app/models/dtos/evaluation_dto.dart';
import 'package:healthy_purr_mobile_app/models/entities/cat_food_analysis.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

Future<double> calculateFoodAffinity(
    double weight,
    double age,
    double sex,
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

  var input = [
    [weight, age, age, sex, eggAllergy, meatAllergy, pigAllergy, milkAllergy, soyAllergy, fishAllergy, cheeseAllergy, chickenAllergy, catFoodAnalysis.analysis!.protein,
      catFoodAnalysis.analysis!.fat, catFoodAnalysis.analysis!.fiber, catFoodAnalysis.analysis!.moisture, catFoodAnalysis.analysis!.calcium, catFoodAnalysis.analysis!.phosphorus,
      catFoodAnalysis.analysis!.ash, catFoodAnalysis.analysis!.carbohydrates, catFoodAnalysis.taurine!.taurine, catFoodAnalysis.ingredients!.egg, catFoodAnalysis.ingredients!.meat, catFoodAnalysis.ingredients!.pig,
      catFoodAnalysis.ingredients!.milk, catFoodAnalysis.ingredients!.soy, catFoodAnalysis.ingredients!.chicken, catFoodAnalysis.ingredients!.fish, catFoodAnalysis.ingredients!.cheese,
      catFoodAnalysis.ingredients!.colorant]
  ];
  var output = List.filled(1, 0).reshape([1, 1]);
  interpreter.run(input, output);

  double result = output[0][0];

  if(result > 1){
    result = 1;
  }

  interpreter.close();

  return result;

}