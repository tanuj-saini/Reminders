import 'dart:convert';

class UserModel {
  final String password;

  final String email;
  UserModel({
    required this.password,
    required this.email,
  });

  UserModel copyWith({
    String? password,
    String? email,
  }) {
    return UserModel(
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      password: map['password'] ?? '',
      email: map['email'] ?? '',
    );
  }

  @override
  String toString() => 'UserModel(password: $password, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.password == password &&
        other.email == email;
  }

  @override
  int get hashCode => password.hashCode ^ email.hashCode;
}
