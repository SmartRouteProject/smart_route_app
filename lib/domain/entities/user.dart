import 'dart:typed_data';

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
