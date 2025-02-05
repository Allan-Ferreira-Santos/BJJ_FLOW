class AuthUserModel {
  final String email;
  final String password;

  AuthUserModel({
    required this.email,
    required this.password,
  });

  static AuthUserModel fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
