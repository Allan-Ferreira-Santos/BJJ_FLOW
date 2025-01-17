class AuthUserModel {
  final String userType;
  final String username;
  final String fullName;
  final String gender;
  final DateTime birthDate;
  final String phone;
  final String email;
  final String cpf;
  final String addressId;
  final String graduationId;
  final String projectId;
  final String paymentId;
  final DateTime registrationDate;
  final DateTime updateDate;

  AuthUserModel({
    required this.userType,
    required this.username,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.cpf,
    required this.addressId,
    required this.graduationId,
    required this.projectId,
    required this.paymentId,
    required this.registrationDate,
    required this.updateDate,
  });

  static AuthUserModel fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      userType: json['userType'],
      username: json['username'],
      fullName: json['fullName'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthDate']),
      phone: json['phone'],
      email: json['email'],
      cpf: json['cpf'],
      addressId: json['addressId'],
      graduationId: json['graduationId'],
      projectId: json['projectId'],
      paymentId: json['paymentId'],
      registrationDate: DateTime.parse(json['registrationDate']),
      updateDate: DateTime.parse(json['updateDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'username': username,
      'fullName': fullName,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'phone': phone,
      'email': email,
      'cpf': cpf,
      'addressId': addressId,
      'graduationId': graduationId,
      'projectId': projectId,
      'paymentId': paymentId,
      'registrationDate': registrationDate.toIso8601String(),
      'updateDate': updateDate.toIso8601String(),
    };
  }
}
