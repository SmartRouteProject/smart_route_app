import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IRouteRepository {
  Future<List<RouteEnt>> getRoutes();

  Future<RouteEnt?> getRoute(int id);

  Future<RouteEnt?> createRoute(CreateRouteDto createRouteDto);

  Future<RouteEnt?> updateRoute(RouteEnt route);

  Future<bool> deleteRoute(String id);
}
