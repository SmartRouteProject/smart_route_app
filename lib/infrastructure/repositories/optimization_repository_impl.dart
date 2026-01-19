import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class OptimizationRepositoryImpl extends IOptimizationRepository {
  final IOptimizationDatasource optimizationDatasource;

  OptimizationRepositoryImpl({IOptimizationDatasource? optimizationDatasource})
    : optimizationDatasource =
          optimizationDatasource ?? OptimizationDatasourceImpl();

  @override
  Future<RouteEnt?> optimizeRoute(
    String routeId,
    OptimizationRequestDto optimizationRequestDto,
  ) {
    return optimizationDatasource.optimizeRoute(routeId, optimizationRequestDto);
  }
}
