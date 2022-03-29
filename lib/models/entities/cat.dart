class Cat {
  final int? catId;
  final String? name;
  final double? weight;
  final int? age;
  final bool? gender;
  final bool? hasDisease;
  final bool? isAllergic;
  bool? status;
  final int? userId;

  Cat({
    this.catId,
    this.name,
    this.weight,
    this.age,
    this.gender,
    this.hasDisease,
    this.isAllergic,
    this.status,
    this.userId
  });

  factory Cat.fromJson(Map<String, dynamic> catJson) {
    return Cat(
        catId: catJson['catId'],
        name: catJson['name'],
        weight: catJson['weight'],
        age: catJson['age'],
        gender: catJson['gender'],
        hasDisease: catJson['hasDisease'],
        isAllergic: catJson['isAllergic'],
        status: catJson['status'],
        userId: catJson['userId']
    );
  }

}