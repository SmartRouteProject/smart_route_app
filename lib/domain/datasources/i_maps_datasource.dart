import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IMapsDatasource {
  Future<List<AddressSearch>> findPlace(String query);
}
