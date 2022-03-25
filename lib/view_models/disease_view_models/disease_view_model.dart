import '../../models/model.dart';

class DiseaseViewModel {
  final Disease disease;

  DiseaseViewModel({required this.disease});

  String? get createdAt => disease.createdAt;

  String? get lastUpdate => disease.lastUpdate;

  int? get diseaseId => disease.diseaseId;

  String? get name => disease.name;

  String? get description => disease.description;

}