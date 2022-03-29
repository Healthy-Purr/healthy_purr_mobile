import '../../models/model.dart';

class CatViewModel {
  final Cat cat;

  CatViewModel({required this.cat});

  int? get catId => cat.catId;

  String? get name => cat.name;

  double? get weight => cat.weight;

  int? get age => cat.age;

  bool? get gender => cat.gender;

  bool? get hasDisease => cat.hasDisease;

  bool? get isAllergic => cat.isAllergic;

  bool? get status => cat.status;

  set newStatus(bool newStatus) => cat.status = newStatus;

  int? get userId => cat.userId;

}