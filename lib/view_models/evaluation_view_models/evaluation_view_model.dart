import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:healthy_purr_mobile_app/models/dtos/evaluation_dto.dart';
import 'package:healthy_purr_mobile_app/models/entities/cat_food_analysis.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/disease_service.dart';
import 'package:healthy_purr_mobile_app/services/evaluation_service.dart';
import 'package:healthy_purr_mobile_app/view_models/cat_view_models/cat_view_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/allergy_service.dart';
import '../../utils/prediction.dart';

class EvaluationViewModel extends ChangeNotifier{

  final List<CatFoodAnalysis> _evaluations =  [];
  List<double> _finalEvaluationList = [];
  final EvaluationService _evaluationService = EvaluationService();
  final EvaluatedFoodDto _evaluatedFoodDto = EvaluatedFoodDto();
  final EvaluationResultDto _evaluationResultDto = EvaluationResultDto();
  int _evaluationsLength = 0;
  CatViewModel _selectedCat = CatViewModel(cat: Cat());
  //Allergies
  double eggAllergy = 0.0;
  double meatAllergy = 0.0;
  double pigAllergy = 0.0;
  double milkAllergy = 0.0;
  double soyAllergy = 0.0;
  double fishAllergy = 0.0;
  double cheeseAllergy = 0.0;
  double chickenAllergy = 0.0;
  //Diseases
  double obesity = 0.0;
  double diabetes = 0.0;
  double cardiac = 0.0;
  double diarrhea  = 0.0;
  double cystitis  = 0.0;
  double kidneyStones = 0.0;
  double malNutrition = 0.0;
  String? address;

  setSelectedCat(CatViewModel newCat){
    _selectedCat = newCat;
  }

  populateEvaluations(int length){
    _finalEvaluationList = List.filled(length, 0.0);
  }


  final List<CatAllergyDto> _catAllergies = [];
  final List<CatDiseaseDto> _catDiseases = [];

  List<CatFoodAnalysis> getEvaluations() {
    return _evaluations;
  }

  List<double> getFinalEvaluationList(){
    return _finalEvaluationList;
  }

  int getEvaluationsLength(){
    return _evaluationsLength;
  }

  clearEvaluationList(){
    if(_evaluations.isNotEmpty){
      _evaluations.clear();
    }
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, outPath,
      quality: 85,
    );

    return result!;
  }

  determinateRegion(String addressRegion){
    address = addressRegion;
  }

  determineLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position currentPosition;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    currentPosition = await Geolocator.getCurrentPosition();

    getAddressFromLatLng(currentPosition);

  }

  getAddressFromLatLng(Position _currentPosition) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude,
          _currentPosition.longitude
      );

      Placemark place = placemarks[0];

      determinateRegion('${place.name!}, ${place.locality!}');

    } catch (e) {
      print(e);
    }
  }

  Future<int> registerEvaluatedFood(CatFoodAnalysis catFoodAnalysis) async {

    _evaluatedFoodDto.protein = catFoodAnalysis.analysis!.protein;
    _evaluatedFoodDto.phosphorus = catFoodAnalysis.analysis!.phosphorus;
    _evaluatedFoodDto.calcium = catFoodAnalysis.analysis!.calcium;
    _evaluatedFoodDto.moisture = catFoodAnalysis.analysis!.moisture;
    _evaluatedFoodDto.fiber = catFoodAnalysis.analysis!.fiber;
    _evaluatedFoodDto.fat = catFoodAnalysis.analysis!.fat;
    _evaluatedFoodDto.hasTaurine = catFoodAnalysis.taurine!.taurine! > 0.0 ? true : false;


    return await _evaluationService.registerEvaluatedFood(_evaluatedFoodDto);

  }


  Future<int> registerEvaluationResult(CatFoodAnalysis catFoodAnalysis, int efDtoId, String name) async{

    _evaluationResultDto.accuracyRate = double.parse(catFoodAnalysis.result.toStringAsFixed(3));

    if(_selectedCat.catId != null){
      _evaluationResultDto.catId = _selectedCat.catId;
      _evaluationResultDto.description = name;
    }
    else{
      _evaluationResultDto.catId = 1;
      _evaluationResultDto.description = name + ":zenpan";
    }
    _evaluationResultDto.userId = UserSession().id!;

    if(address != null){
      _evaluationResultDto.location = address;
    }
    else{
      _evaluationResultDto.location = "Ubicación no disponible";
    }

    _evaluationResultDto.evaluatedFoodId = efDtoId;

    return await _evaluationService.registerEvaluationResult(_evaluationResultDto);
  }


  Future<void> registerEvaluationPhoto(File file, int erDtoId) async{
    await compressFile(file).then((compressedFile){
      _evaluationService.uploadEvaluationImage(compressedFile, erDtoId);
    });
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

  Future<void> populateCatAllergyList() async {

    if(_catAllergies.isNotEmpty){
      _catAllergies.clear();
    }

    await AllergyService().getCatAllergies(_selectedCat).then((auxCatAllergyList) {
      for(var catAllergyDto in auxCatAllergyList) {

        if(catAllergyDto.status == 1) {
          _catAllergies.add(catAllergyDto);
        }

      }
    });

    validateAllergyList();

  }

  Future<void> populateCatDiseaseList() async {

    if(_catDiseases.isNotEmpty){
      _catDiseases.clear();
    }

    await DiseaseService().getCatDiseases(_selectedCat).then((auxCatDiseaseList) {
      for(var catDiseaseDto in auxCatDiseaseList) {

        if(catDiseaseDto.status == 1) {
          _catDiseases.add(catDiseaseDto);
        }

      }
    });

    validateDiseaseList();

  }


  validateAllergyList(){
    for(CatAllergyDto allergyDto in _catAllergies){
      switch(allergyDto.allergyId!){
        case 1:
          pigAllergy = 1.0;
          break;
        case 2:
          meatAllergy = 1.0;
          break;
        case 3:
          milkAllergy = 1.0;
          break;
        case 4:
          eggAllergy = 1.0;
          break;
        case 5:
          soyAllergy = 1.0;
          break;
        case 6:
          cheeseAllergy = 1.0;
          break;
        case 7:
          chickenAllergy = 1.0;
          break;
      }
    }
  }

  validateDiseaseList(){
    for(CatDiseaseDto diseaseDto in _catDiseases){

      switch(diseaseDto.diseaseId!){
        case 1:
          obesity = 1.0;
          break;
        case 2:
          diabetes = 1.0;
          break;
        case 3:
          cardiac = 1.0;
          break;
        case 4:
          diarrhea = 1.0;
          break;
        case 5:
          cystitis = 1.0;
          break;
        case 6:
          kidneyStones = 1.0;
          break;
        case 7:
          malNutrition = 1.0;
          break;
      }
    }
  }

  Future<void> evaluateCatFood(CatFoodAnalysis catFoodAnalysis, int fileIndex) async{

    if(_selectedCat.catId != null){

      await calculateFoodAffinity(_selectedCat.weight!, _selectedCat.age!.toDouble(),
          _selectedCat.gender == true ? 1.0 : 0.0, obesity, diabetes, cardiac, diarrhea, cystitis, kidneyStones, malNutrition,
          eggAllergy, meatAllergy, pigAllergy, milkAllergy, soyAllergy, fishAllergy, cheeseAllergy, chickenAllergy,
          catFoodAnalysis).then((result){
            if(result > 0){
              catFoodAnalysis.setResult(result);
              _evaluations[fileIndex] = catFoodAnalysis;
              _finalEvaluationList[fileIndex] = result;
              _evaluationsLength++;
            }
            else{
              _finalEvaluationList.clear();
            }
         //result;
      });
    }
    else{
      await calculateFoodAffinity(0.0, 1, 1, 0.0, 0.0, 0.0, 0.0,0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, catFoodAnalysis).then((result){
        if(result > 0){
          catFoodAnalysis.setResult(result);
          _evaluations[fileIndex] = catFoodAnalysis;
          _finalEvaluationList[fileIndex] = result;
          _evaluationsLength++;
        }
        else{
          _finalEvaluationList.clear();
        }
      });
    }

    notifyListeners();
  }
}