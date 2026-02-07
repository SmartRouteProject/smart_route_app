import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IOptimizationRepository {
  Future<RouteEnt?> optimizeRoute(
    String routeId,
    OptimizationRequestDto optimizationRequestDto,
  );
}
