import 'package:smart_route_app/domain/domain.dart';

abstract class IReturnAddressRepository {
  Future<List<ReturnAddress>> getReturnAddresses();

  Future<ReturnAddress?> createReturnAddress(ReturnAddress address);

  Future<ReturnAddress?> editReturnAddress(String id, ReturnAddress address);

  Future<bool> deleteReturnAddress(String id);
}
