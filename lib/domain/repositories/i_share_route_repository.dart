import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IShareRouteRepository {
  Future<String?> shareRoute(String routeId);

  Future<RouteEnt?> acceptSharedRoute(String sharedRouteId);
}
