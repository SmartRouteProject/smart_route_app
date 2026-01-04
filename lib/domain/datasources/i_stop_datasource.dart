import 'package:smart_route_app/domain/domain.dart';

abstract class IStopDatasource {
  Future<List<Stop>> getStops(String routeId);

  Future<Stop?> createStop(String routeId, Stop stop);

  Future<Stop?> editStop(String routeId, Stop stop);

  Future<bool> deleteStop(String routeId, String stopId);
}
