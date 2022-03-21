import 'package:flutter/cupertino.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:provider/provider.dart';

import '../../models/model.dart';
import '../../view_models/view_model.dart';

class CatListViewModel {

  final List<CatViewModel> _cats = [];

  List<CatViewModel> getCats() {
    return _cats;
  }

  Future<void> populateCatList(BuildContext context) async {
    final user = Provider.of<UserViewModel>(context, listen: false).user;

    List<Cat> auxCatList = await CatService().getCatsByUserId(user.userId!.toString());

    for(var cat in auxCatList) {
      _cats.add(CatViewModel(cat: cat));
    }

  }

}