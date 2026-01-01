import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class StopRepositoryImpl extends IStopRepository {
  final IStopDatasource stopDatasource;

  StopRepositoryImpl({IStopDatasource? stopDatasource})
    : stopDatasource = stopDatasource ?? StopDatasourceImpl();

  @override
  Future<List<Stop>> getStops(String routeId) {
    return stopDatasource.getStops(routeId);
  }

  @override
  Future<Stop?> createStop(String routeId, Stop stop) {
    return stopDatasource.createStop(routeId, stop);
  }

  @override
  Future<Stop?> editStop(String routeId, Stop stop) {
    return stopDatasource.editStop(routeId, stop);
  }

  @override
  Future<bool> deleteStop(String routeId, String stopId) {
    return stopDatasource.deleteStop(routeId, stopId);
  }
}
