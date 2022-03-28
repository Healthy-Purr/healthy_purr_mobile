import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class EvaluationViewModel{

  final List<String> _evaluations =  [];

  List<String> getEvaluations() {
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
    
    if(_text.isNotEmpty){
      _evaluations.add('');
      _evaluations[fileIndex] = 'Recomendado';
    }
    else{
      _evaluations.add('');
      _evaluations[fileIndex] = 'No Recomendado';
    }
    
  }
}