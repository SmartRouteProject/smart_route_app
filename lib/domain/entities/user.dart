import 'dart:convert';
import 'dart:io';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';

class User {
  String? id;
  String name;
  String lastName;
  String email;
  String password;
  List<ReturnAddress> returnAddresses;
  List<RouteEnt> routes;
  File? profilePicture;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    this.returnAddresses = const [],
    this.routes = const [],
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
      routes: (json['routes'] as List<dynamic>? ?? [])
          .map((route) => RouteEnt.fromJson(route as Map<String, dynamic>))
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
      routes: const [],
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
      'routes': routes.map((route) => route.toJson()).toList(),
      'profilePicture': _fileToBase64(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? lastName,
    String? email,
    String? password,
    List<ReturnAddress>? returnAddresses,
    List<RouteEnt>? routes,
    File? profilePicture,
    bool clearProfilePicture = false,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      returnAddresses: returnAddresses ?? this.returnAddresses,
      routes: routes ?? this.routes,
      profilePicture: clearProfilePicture ? null : profilePicture ?? this.profilePicture,
    );
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
