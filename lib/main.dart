import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/config/constants/env.dart';
import 'package:smart_route_app/config/router/app_router.dart';
import 'package:smart_route_app/config/theme/app_theme.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Geolocator.requestPermission();

  await Env.init();

  await initDio();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
    );
  }
}

Future<void> initDio() async {
  DioFlowConfig.initialize(
    baseUrl: Env.apiUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  );

  // 🚀 Initialize the client
  await ApiClient.initialize();

  // 🔑 Initialize token management
  await TokenManager.initialize();

  TokenManager.setRefreshHandler((refreshToken) async {
    final refreshResp = await DioRefreshTokenRequestHandle.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    final data = refreshResp.data!;

    return RefreshTokenResponse(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String?,
      expiry: DateTime.now().add(Duration(days: 29)),
    );
  });
}
