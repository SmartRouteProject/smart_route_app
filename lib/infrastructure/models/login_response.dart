import 'package:smart_route_app/domain/domain.dart';

class LoginResponse {
  final User? user;
  final bool validated;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  LoginResponse({
    this.user,
    this.validated = false,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: json['user'] == null ? null : User.fromJson(json['user']),
      validated: json['validated'] ?? false,
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
    );
  }
}
