import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluated_food.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluation_result.dart';
import 'package:healthy_purr_mobile_app/services/evaluation_service.dart';


class EvaluationRecordViewModel extends ChangeNotifier{

  List<EvaluationResult> _evaluations =  [];
  List<EvaluatedFood> _evaluatedFeed =  [];
  final EvaluationService _evaluationService = EvaluationService();

  List<EvaluationResult> getEvaluations() {
    return _evaluations;
  }

  setEvaluations(List<EvaluationResult> evaluations){
    _evaluations = evaluations;
    notifyListeners();
  }

  setEvaluatedFeed(List<EvaluatedFood> evaluatedFeed){
    _evaluatedFeed = evaluatedFeed;
    notifyListeners();
  }

  List<EvaluatedFood> getEvaluatedFeed(){
    return _evaluatedFeed;
  }

  clearEvaluationList(){
    _evaluations.clear();
  }

  Future<void> populateEvaluationResultList() async {
    _evaluations =  await _evaluationService.getUserEvaluationResult();
    _evaluatedFeed = List.filled(_evaluations.length, EvaluatedFood());
    await populateEvaluationFeed();
  }

  Future<void> populateEvaluationFeed() async {
    for(int i = 0; i < _evaluations.length; i ++){
      _evaluationService.getEvaluatedFood(_evaluations[i].evaluatedFoodId!).then((value){
        _evaluatedFeed[i] = value;
      });
    }

    setEvaluations(_evaluations);
    setEvaluatedFeed(_evaluatedFeed);
  }

  Future<ImageProvider> getImageProvider(int id) async{
    return await _evaluationService.getEvaluationImage(id);
  }

}