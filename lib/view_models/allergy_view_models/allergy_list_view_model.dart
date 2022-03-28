import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:provider/provider.dart';
import '../../view_models/view_model.dart';

class AllergyListViewModel {

  final List<AllergyViewModel> _allergyList =  [];

  final List<CatAllergyDto> _catAllergyDtoList = [];

  final List<Map<String, String>> _catAllergiesList = [];

  List<AllergyViewModel> getAllergies() {
    return _allergyList;
  }

  List<CatAllergyDto> getCatAllergiesDto() {
    return _catAllergyDtoList;
  }

  List<Map<String, String>> getCatAllergies() {
    return _catAllergiesList;
  }

  Future<void> populateAllergyList() async {
    List<Allergy> auxAllergyList = await AllergyService().getAllAllergies();

    _allergyList.clear();

    for(var allergy in auxAllergyList) {
      _allergyList.add(AllergyViewModel(allergy: allergy));
    }

  }

  Future<void> populateCatAllergyList(BuildContext context) async {

    _catAllergyDtoList.clear();
    _catAllergiesList.clear();

    final cat = Provider.of<CatListViewModel>(context, listen: false).selectedCat;

    List<CatAllergyDto> auxCatAllergyList = await AllergyService().getCatAllergies(cat);

    for(var catAllergyDto in auxCatAllergyList) {

      if(catAllergyDto.status == 1) {
        _catAllergyDtoList.add(catAllergyDto);
      }

    }

    for(var allergy in _allergyList) {
      for(var allergyDto in _catAllergyDtoList) {
        if(allergyDto.allergyId == allergy.allergyId) {
          _catAllergiesList.add({"name": allergy.name!, "descripion": allergy.description!});
        }
      }
    }

  }

}