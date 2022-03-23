class Disease {
  final String? createdAt;
  final String? lastUpdate;
  final int? diseaseId;
  final String? name;
  final String? description;

  Disease({
    this.createdAt,
    this.lastUpdate,
    this.diseaseId,
    this.name,
    this.description
  });

  factory Disease.formJson(Map<String, dynamic> diseaseJson) {
    return Disease(
      createdAt: diseaseJson['createdAt'],
      lastUpdate: diseaseJson['lastUpdate'],
      diseaseId: diseaseJson['diseaseId'],
      name: diseaseJson['name'],
      description: diseaseJson['description']
    );
  }

}