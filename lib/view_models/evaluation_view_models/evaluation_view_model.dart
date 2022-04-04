import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:healthy_purr_mobile_app/models/dtos/evaluation_dto.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluation_result.dart';

class EvaluationViewModel{

  final List<EvaluatedFoodDto> _evaluations =  [];

  List<EvaluatedFoodDto> getEvaluations() {
    return _evaluations;
  }

  clearEvaluationList(){
    _evaluations.clear();
  }

  Future<void> evaluateCatFood(File file, int fileIndex) async{

    String _text = '';

    final textDetector = GoogleMlKit.vision.textDetector();
    dynamic _recognisedText;

    final inputImage = InputImage.fromFilePath(file.path);

    _recognisedText = await textDetector.processImage(inputImage);
    _text = _recognisedText.text;

    _evaluations.add(EvaluatedFoodDto());

    if(_text.isNotEmpty){
      _evaluations[fileIndex].protein = 10.0;
      _evaluations[fileIndex].fat = 15.0;
      _evaluations[fileIndex].moisture = 12.0;
      _evaluations[fileIndex].fiber = 20.0;
      _evaluations[fileIndex].calcium = 50.0;
      _evaluations[fileIndex].phosphorus = 8.0;
    }
    else{
      _evaluations[fileIndex].protein = 5.0;
      _evaluations[fileIndex].fat = 10.0;
      _evaluations[fileIndex].moisture = 5.0;
      _evaluations[fileIndex].fiber = 5.0;
      _evaluations[fileIndex].calcium = 20.0;
      _evaluations[fileIndex].phosphorus = 5.0;
    }
    
  }
}