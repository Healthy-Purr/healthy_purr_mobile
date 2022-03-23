class Allergy {
  final String? createdAt;
  final String? lastUpdate;
  final int? allergyId;
  final String? name;
  final String? description;

  Allergy({
    this.createdAt,
    this.lastUpdate,
    this.allergyId,
    this.name,
    this.description
  });

  factory Allergy.formJson(Map<String, dynamic> allergyJson) {
    return Allergy(
        createdAt: allergyJson['createdAt'],
        lastUpdate: allergyJson['lastUpdate'],
        allergyId: allergyJson['diseaseId'],
        name: allergyJson['name'],
        description: allergyJson['description']
    );
  }

}