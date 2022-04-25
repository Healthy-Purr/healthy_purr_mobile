import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:healthy_purr_mobile_app/models/dtos/evaluation_dto.dart';
import 'package:healthy_purr_mobile_app/models/entities/cat_food_analysis.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluation_result.dart';
import 'package:healthy_purr_mobile_app/services/evaluation_service.dart';

import '../../utils/prediction.dart';

class EvaluationViewModel{

  final List<CatFoodAnalysis> _evaluations =  [];
  final List<double> _finalEvaluationList = [];
  final EvaluationService _evaluationService = EvaluationService();

  List<CatFoodAnalysis> getEvaluations() {
    return _evaluations;
  }

  List<double> getFinalEvaluationList(){
    return _finalEvaluationList;
  }

  clearEvaluationList(){
    _evaluations.clear();
  }

  Future<String> getTextCatFood(File file) async{

    String _text = '';

    final textDetector = GoogleMlKit.vision.textDetector();
    dynamic _recognisedText;

    final inputImage = InputImage.fromFilePath(file.path);

    _recognisedText = await textDetector.processImage(inputImage);
    _text = _recognisedText.text;

    _evaluations.add(CatFoodAnalysis());

    return _text;
  }

  Future<CatFoodAnalysis> getCatFoodAnalysis(String text) async{
    return await _evaluationService.getFoodEvaluation(text);
  }


  Future<void> evaluateCatFood(CatFoodAnalysis catFoodAnalysis, int fileIndex) async{
    await calculateFoodAffinity(0.0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, catFoodAnalysis).then((result){
      catFoodAnalysis.setResult(result);
      _evaluations[fileIndex] = catFoodAnalysis;
      _finalEvaluationList.add(result);
    });
  }
}