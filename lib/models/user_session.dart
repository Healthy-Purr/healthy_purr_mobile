class UserSession{

  int? id;
  String? token, userName, name, lastName;

  static final UserSession _singleton = UserSession._internal();

  factory UserSession(){
    return _singleton;
  }

  UserSession._internal();

}