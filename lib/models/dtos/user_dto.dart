class UserRegisterDto {
  final String name;
  final String lastName;
  final String email;
  final String password;

  UserRegisterDto(
      this.email,
      this.password,
      this.name,
      this.lastName
    );
}

class UserLoginDto {
  final String email;
  final String password;

  UserLoginDto(this.email, this.password);
}

class UserUpdateDto {
  final String name;
  final String lastName;
  final String userName;
  final String password;
  final String birthDate;

  UserUpdateDto(
    this.name,
    this.lastName,
    this.userName,
    this.password,
    this.birthDate
  );
}