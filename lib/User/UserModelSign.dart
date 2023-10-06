import 'dart:convert';

class UserModelSign {
  final String name;
  final String userUid;
  final String email;
  UserModelSign({
    required this.name,
    required this.userUid,
    required this.email,
  });

  UserModelSign copyWith({
    String? name,
    String? userUid,
    String? email,
  }) {
    return UserModelSign(
      name: name ?? this.name,
      userUid: userUid ?? this.userUid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userUid': userUid,
      'email': email,
    };
  }

  factory UserModelSign.fromMap(Map<String, dynamic> map) {
    return UserModelSign(
      name: map['name'] ?? '',
      userUid: map['userUid'] ?? '',
      email: map['email'] ?? '',
    );
  }

  @override
  String toString() =>
      'UserModelSign(name: $name, userUid: $userUid, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModelSign &&
        other.name == name &&
        other.userUid == userUid &&
        other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ userUid.hashCode ^ email.hashCode;
}
