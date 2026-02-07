import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IMapsRepository {
  Future<List<AddressSearch>> findPlace(String query);
}
