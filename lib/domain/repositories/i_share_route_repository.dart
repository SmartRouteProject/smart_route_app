import 'package:smart_route_app/domain/domain.dart';

abstract class IShareRouteRepository {
  Future<String?> shareRoute(String routeId);

  Future<RouteEnt?> acceptSharedRoute(String sharedRouteId);
}
