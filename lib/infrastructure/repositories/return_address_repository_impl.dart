import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class ReturnAddressRepositoryImpl extends IReturnAddressRepository {
  final IReturnAddressDatasource returnAddressDatasource;

  ReturnAddressRepositoryImpl({IReturnAddressDatasource? returnAddressDatasource})
    : returnAddressDatasource =
          returnAddressDatasource ?? ReturnAddressDatasourceImpl();

  @override
  Future<List<ReturnAddress>> getReturnAddresses() {
    return returnAddressDatasource.getReturnAddresses();
  }

  @override
  Future<ReturnAddress?> createReturnAddress(ReturnAddress address) {
    return returnAddressDatasource.createReturnAddress(address);
  }

  @override
  Future<ReturnAddress?> editReturnAddress(String id, ReturnAddress address) {
    return returnAddressDatasource.editReturnAddress(id, address);
  }

  @override
  Future<bool> deleteReturnAddress(String id) {
    return returnAddressDatasource.deleteReturnAddress(id);
  }
}
