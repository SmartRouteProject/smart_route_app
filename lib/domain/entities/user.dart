import 'dart:convert';
import 'dart:io';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/domain/entities/return_adress.dart';

class User {
  String? id;
  String name;
  String lastName;
  String email;
  String password;
  List<ReturnAddress> returnAddresses;
  File? profilePicture;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    this.returnAddresses = const [],
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      returnAddresses: (json['returnAddresses'] as List<dynamic>? ?? [])
          .map(
            (address) =>
                ReturnAddress.fromJson(address as Map<String, dynamic>),
          )
          .toList(),
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
      returnAddresses: const [],
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
      'returnAddresses': returnAddresses.map((ra) => ra.toMap()).toList(),
      'profilePicture': _fileToBase64(),
    };
  }

  static File? _fileFromBase64(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    try {
      final bytes = base64Decode(value);
      final fileName = 'profile_${DateTime.now().microsecondsSinceEpoch}.png';
      final file = File('${Directory.systemTemp.path}/$fileName');
      file.writeAsBytesSync(bytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  String _fileToBase64() {
    try {
      if (profilePicture == null) return '';
      final bytes = profilePicture!.readAsBytesSync();
      return base64Encode(bytes);
    } catch (_) {
      return '';
    }
  }
}
