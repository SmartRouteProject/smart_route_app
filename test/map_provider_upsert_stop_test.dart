import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';

class _FakeAuthRepository implements IAuthRepository {
  @override
  Future<LoginResponse> login(String email, String password) =>
      throw UnimplementedError();

  @override
  Future<LoginResponse> loginWithGoogle(String idToken) =>
      throw UnimplementedError();

  @override
  Future<bool> register(User user) => throw UnimplementedError();

  @override
  Future<String> refreshToken(String token) => throw UnimplementedError();

  @override
  Future<bool> logout() => throw UnimplementedError();

  @override
  Future<bool> sendEmailVerification(String email) => throw UnimplementedError();

  @override
  Future<bool> verifyEmail(String email, String code) =>
      throw UnimplementedError();

  @override
  Future<bool> requestPasswordChange(String email) =>
      throw UnimplementedError();

  @override
  Future<bool> verifyPasswordChange(
    String email,
    String code,
    String newPassword,
  ) =>
      throw UnimplementedError();
}

class _FakeRouteRepository implements IRouteRepository {
  @override
  Future<List<RouteEnt>> getRoutes() => throw UnimplementedError();

  @override
  Future<RouteEnt?> getRoute(int id) => throw UnimplementedError();

  @override
  Future<RouteEnt?> createRoute(CreateRouteDto createRouteDto) =>
      throw UnimplementedError();

  @override
  Future<RouteEnt?> updateRoute(RouteEnt route) => throw UnimplementedError();

  @override
  Future<bool> deleteRoute(String id) => throw UnimplementedError();
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier({required Ref ref, required User user})
    : super(
        ref: ref,
        authRepository: _FakeAuthRepository(),
        routeRepository: _FakeRouteRepository(),
      ) {
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }
}

class _TestMapNotifier extends MapNotifier {
  _TestMapNotifier({required Ref ref})
    : super(ref: ref, routeRepository: _FakeRouteRepository());

  @override
  Future<void> setCurrentPosition() async {
    // Avoid Geolocator calls in tests.
  }
}

void main() {
  test('upsertStop keeps auth user routes in sync', () {
    final route = RouteEnt(
      id: 'route-1',
      name: 'Ruta 1',
      geometry: null,
      creationDate: DateTime(2025, 10, 29),
      state: RouteState.planned,
      stops: const [],
    );
    final user = User(
      id: 'user-1',
      email: 'user@example.com',
      password: 'secret',
      name: 'User',
      lastName: 'One',
      routes: [route],
    );

    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(
          (ref) => _TestAuthNotifier(ref: ref, user: user),
        ),
        mapProvider.overrideWith((ref) => _TestMapNotifier(ref: ref)),
      ],
    );
    addTearDown(container.dispose);

    final mapNotifier = container.read(mapProvider.notifier);
    mapNotifier.setRoutes([route]);
    mapNotifier.selectRoute(route);

    final originalStop = PickupStop(
      id: null,
      latitude: -34.9,
      longitude: -56.1,
      address: 'Temporal',
      order: 1,
      description: 'temp',
    );
    final savedStop = PickupStop(
      id: 'stop-1',
      latitude: -34.9,
      longitude: -56.1,
      address: 'Nueva parada',
      order: 1,
      description: 'real',
    );

    mapNotifier.upsertStop(
      originalStop: originalStop,
      updatedStop: savedStop,
    );

    final updatedRoute = container.read(mapProvider).selectedRoute;
    expect(
      updatedRoute?.stops.any((stop) => stop.address == savedStop.address),
      true,
    );

    final updatedUser = container.read(authProvider).user;
    final userRoute = updatedUser?.routes.firstWhere(
      (candidate) => candidate.id == route.id,
    );
    expect(
      userRoute?.stops.any((stop) => stop.address == savedStop.address),
      true,
    );
  });
}
