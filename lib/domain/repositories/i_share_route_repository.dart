import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IShareRouteRepository {
  Future<bool> shareRoute(String routeId);

  Future<bool> acceptSharedRoute(String sharedRouteId);
}
