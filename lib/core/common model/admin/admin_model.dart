// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdminModel {
  final String? id;
  final String name;
  final String fcmtoken;
  final String role;
  final String email;
  AdminModel({
    this.id,
    required this.name,
    required this.fcmtoken,
    required this.role,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'fcmtoken': fcmtoken,
      'role': role,
      'email': email,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      fcmtoken: map['fcmtoken'] as String,
      role: map['role'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminModel(id: $id, name: $name, fcmtoken: $fcmtoken, role: $role, email: $email)';
  }
}
