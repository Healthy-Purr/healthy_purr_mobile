class CatRegisterDto {
  final String name;
  final double weight;
  final int age;
  final bool gender;
  final bool hasDisease;
  final bool isAllergic;

  CatRegisterDto(
      this.name,
      this.age,
      this.weight,
      this.gender,
      this.hasDisease,
      this.isAllergic
   );
}

class CatDiseaseDto {
  final int? catId;
  final int? diseaseId;
  final int? status;

  CatDiseaseDto({this.catId, this.diseaseId, this.status});

  factory CatDiseaseDto.fromJson(Map<String, dynamic> catDiseaseJson) {
    return CatDiseaseDto(
        catId: catDiseaseJson['catId'],
        diseaseId: catDiseaseJson['diseaseId'],
        status: catDiseaseJson['status']
    );
  }
}

class CatAllergyDto {
  final int? catId;
  final int? allergyId;
  final int? status;

  CatAllergyDto({this.catId, this.allergyId, this.status});

  factory CatAllergyDto.fromJson(Map<String, dynamic> catAllergyJson) {
    return CatAllergyDto(
        catId: catAllergyJson['catId'],
        allergyId: catAllergyJson['diseaseId'],
        status: catAllergyJson['status']
    );
  }
}