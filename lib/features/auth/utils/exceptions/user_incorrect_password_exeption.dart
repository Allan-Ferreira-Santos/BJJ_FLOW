class UserIncorrectPasswordExeption implements Exception {
  final String? message;

  UserIncorrectPasswordExeption({this.message});
}
