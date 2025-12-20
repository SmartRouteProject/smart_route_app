import 'package:smart_route_app/domain/domain.dart';

abstract class IRouteDatasource {
  Future<List<RouteEnt>> getRoutes();

  Future<RouteEnt?> getRoute(int id);

  Future<RouteEnt?> createRoute(RouteEnt route);

  Future<RouteEnt?> updateRoute(RouteEnt route);

  Future<bool> deleteRoute(int id);
}
