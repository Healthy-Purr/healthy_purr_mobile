class User {
  final int? userId;
  final String? name;
  final String? lastName;
  final String? email;
  final DateTime? birthDate;

  User({
    this.userId,
    this.name,
    this.lastName,
    this.email,
    this.birthDate
  });

  factory User.fromJson(Map<String, dynamic> userJson) {
    return User(
      userId: userJson['userId'],
      email: userJson['username'],
      name: userJson['name'],
      lastName: userJson['lastName'],
      birthDate: DateTime.parse(userJson['birthDate']),
    );
  }

}