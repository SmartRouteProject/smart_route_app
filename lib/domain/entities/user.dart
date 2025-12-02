import 'dart:typed_data';

import 'package:smart_route_app/presentation/providers/providers.dart';

class User {
  String? id;
  String name;
  String lastName;
  String email;
  String password;
  Uint8List profilePicture;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      profilePicture: Uint8List.fromList(
        json['profilePicture'] is int
            ? [json['profilePicture']]
            : List<int>.from(json['profilePicture'] ?? []),
      ),
    );
  }

  factory User.fromSignupForm(SignupFormState formState) {
    return User(
      id: '',
      name: formState.userName.value,
      lastName: formState.userLastName.value,
      email: formState.email.value,
      password: formState.password.value,
      profilePicture: Uint8List.fromList([]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'profilePicture': profilePicture,
    };
  }
}
