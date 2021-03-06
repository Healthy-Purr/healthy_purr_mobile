import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:provider/provider.dart';
import '../../view_models/view_model.dart';

class DiseaseListViewModel {

  final List<DiseaseViewModel> _diseaseList =  [];

  final List<CatDiseaseDto> _catDiseasesDtoList = [];

  final List<Map<String, String>> _catDiseasesList = [];

  List<DiseaseViewModel> getDiseases() {
    return _diseaseList;
  }

  List<CatDiseaseDto> getCatDiseasesDto() {
    return _catDiseasesDtoList;
  }

  List<Map<String, String>> getCatDiseases() {
    return _catDiseasesList;
  }

  Future<void> registerDiseaseList(CatViewModel cat, List<String> catDiseases) async{

    for(String disease in catDiseases){
      await DiseaseService().registerCatDiseases(cat, getDiseaseId(disease));
    }

  }

  int getDiseaseId(String diseaseName){
    return _diseaseList.where((element) => element.name == diseaseName).first.diseaseId!;
  }

  Future<void> populateDiseaseList() async {
    List<Disease> auxDiseaseList = await DiseaseService().getAllDiseases();

    _diseaseList.clear();

    for(var disease in auxDiseaseList) {
      _diseaseList.add(DiseaseViewModel(disease: disease));
    }

  }

  Future<void> deactivateCatDiseasesList(BuildContext context) async {
    for(var disease in _catDiseasesDtoList) {
      await DiseaseService().deactivateDisease(disease.catId!, disease.diseaseId!);
    }
  }

  Future<void> populateCatDiseasesList(BuildContext context) async {

    _catDiseasesDtoList.clear();
    _catDiseasesList.clear();

    final cat = Provider.of<CatListViewModel>(context, listen: false).selectedCat;

    List<CatDiseaseDto> auxCatDiseaseList = await DiseaseService().getCatDiseases(cat);

    for(var catDiseaseDto in auxCatDiseaseList) {

      if(catDiseaseDto.status == 1) {
        _catDiseasesDtoList.add(catDiseaseDto);
      }

    }

    for(var disease in _diseaseList) {
      for(var diseaseDto in _catDiseasesDtoList) {
        if(diseaseDto.diseaseId == disease.diseaseId) {
          _catDiseasesList.add({"name": disease.name!, "description": disease.description!});
        }
      }
    }

  }

}