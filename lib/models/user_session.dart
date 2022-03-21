class UserSession{

  int? id;
  String? token, userName;

  static final UserSession _singleton = UserSession._internal();

  factory UserSession(){
    return _singleton;
  }

  UserSession._internal();

}