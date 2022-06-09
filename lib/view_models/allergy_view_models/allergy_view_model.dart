import '../../models/model.dart';

class AllergyViewModel {
  final Allergy allergy;

  AllergyViewModel({required this.allergy});

  String? get createdAt => allergy.createdAt;

  String? get lastUpdate => allergy.lastUpdate;

  int? get allergyId => allergy.allergyId;

  String? get name => allergy.name;

  String? get description => allergy.description;

}