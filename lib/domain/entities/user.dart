import 'dart:typed_data';

import 'package:smart_route_app/presentation/providers/providers.dart';

class User {
  String email;
  String password;
  String name;
  String lastName;
  Uint8List profilePicture;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePicture: Uint8List.fromList(
        List<int>.from(json['profilePicture'] ?? []),
      ),
    );
  }

  factory User.fromSignupForm(SignupFormState formState) {
    return User(
      email: formState.email.value,
      password: formState.password.value,
      name: formState.userName.value,
      lastName: formState.userLastName.value,
      profilePicture: Uint8List.fromList([]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }
}
