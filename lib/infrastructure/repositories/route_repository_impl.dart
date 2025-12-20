import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class RouteRepositoryImpl extends IRouteRepository {
  final IRouteDatasource routeDatasource;

  RouteRepositoryImpl({IRouteDatasource? routeDatasource})
    : routeDatasource = routeDatasource ?? RouteDatasourceImpl();

  @override
  Future<List<RouteEnt>> getRoutes() {
    return routeDatasource.getRoutes();
  }

  @override
  Future<RouteEnt?> getRoute(int id) {
    return routeDatasource.getRoute(id);
  }

  @override
  Future<RouteEnt?> createRoute(RouteEnt route) {
    return routeDatasource.createRoute(route);
  }

  @override
  Future<RouteEnt?> updateRoute(RouteEnt route) {
    return routeDatasource.updateRoute(route);
  }

  @override
  Future<bool> deleteRoute(int id) {
    return routeDatasource.deleteRoute(id);
  }
}
