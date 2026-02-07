import 'package:smart_route_app/domain/domain.dart';

abstract class IShareRouteDatasource {
  Future<String?> shareRoute(String routeId);

  Future<RouteEnt?> acceptSharedRoute(String sharedRouteId);
}
