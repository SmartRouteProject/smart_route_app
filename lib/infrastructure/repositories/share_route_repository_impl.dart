import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class ShareRouteRepositoryImpl extends IShareRouteRepository {
  final IShareRouteDatasource shareRouteDatasource;

  ShareRouteRepositoryImpl({IShareRouteDatasource? shareRouteDatasource})
    : shareRouteDatasource =
          shareRouteDatasource ?? ShareRouteDatasourceImpl();

  @override
  Future<bool> shareRoute(String routeId) {
    return shareRouteDatasource.shareRoute(routeId);
  }

  @override
  Future<bool> acceptSharedRoute(String sharedRouteId) {
    return shareRouteDatasource.acceptSharedRoute(sharedRouteId);
  }
}
