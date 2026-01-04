import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class MapsRepositoryImpl extends IMapsRepository {
  final IMapsDatasource mapsDatasource;

  MapsRepositoryImpl({IMapsDatasource? mapsDatasource})
    : mapsDatasource = mapsDatasource ?? MapsDatasourceImpl();

  @override
  Future<List<AddressSearch>> findPlace(String query) {
    return mapsDatasource.findPlace(query);
  }
}
