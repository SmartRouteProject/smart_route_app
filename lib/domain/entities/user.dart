import 'dart:convert';
import 'dart:io';

import 'package:smart_route_app/presentation/providers/providers.dart';

class User {
  String? id;
  String name;
  String lastName;
  String email;
  String password;
  File? profilePicture;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      profilePicture: _fileFromBase64(json['profilePicture']),
    );
  }

  factory User.fromSignupForm(SignupFormState formState) {
    return User(
      id: '',
      name: formState.userName.value,
      lastName: formState.userLastName.value,
      email: formState.email.value,
      password: formState.password.value,
      profilePicture: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'profilePicture': profilePicture?.path ?? '',
    };
  }

  static File? _fileFromBase64(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    try {
      final bytes = base64Decode(value);
      final fileName =
          'profile_${DateTime.now().microsecondsSinceEpoch}.png';
      final file = File('${Directory.systemTemp.path}/$fileName');
      file.writeAsBytesSync(bytes);
      return file;
    } catch (_) {
      return null;
    }
  }
}
