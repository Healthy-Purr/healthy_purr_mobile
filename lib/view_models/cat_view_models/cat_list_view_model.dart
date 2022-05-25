import 'package:flutter/cupertino.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';

import '../../models/model.dart';
import '../../view_models/view_model.dart';

class CatListViewModel extends ChangeNotifier {

  final List<CatViewModel> _catList = [];

  final List<ImageProvider> _catImages = [];

  late CatViewModel selectedCat;

  late NetworkImage newImage;

  List<CatViewModel> getCats() {
    return _catList;
  }

  updateCatList(CatViewModel cat){
    int index = _catList.indexOf(_catList.where((element) => element.catId! == cat.catId!).first);
    _catList[index] = cat;
    notifyListeners();
  }

  deleteCat(CatViewModel selectedCat){
    int index = _catList.indexOf(_catList.where((element) => element.catId! == selectedCat.catId!).first);
    _catList[index].newStatus = false;
    notifyListeners();
  }

  List<ImageProvider> getCatsImages() {
    return _catImages;
  }

  Future<void> populateCatList(BuildContext context) async {

    final userId = UserSession().id;

    List<Cat> auxCatList = await CatService().getCatsByUserId(userId.toString());

    _catList.clear();

    for(var cat in auxCatList) {
      if(cat.status != false){
        _catList.add(CatViewModel(cat: cat));
      }
    }

    notifyListeners();

  }

  setCatImageAtIndex(int index, ImageProvider newImage){
    _catImages[index] = newImage;
    notifyListeners();
  }

  Future<void> populateCatsImages(BuildContext context) async {

    List<NetworkImage> auxList = [];

    for(var cat in _catList) {
      auxList.add(await CatService().getCatImage(cat));
    }

    _catImages.clear();

    for(var image in auxList) {
      _catImages.add(image);
    }

    notifyListeners();

  }

}