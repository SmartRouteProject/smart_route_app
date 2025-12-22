import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class UserRepositoryImpl extends IUserRepository {
  final IUserDatasource userDatasource;

  UserRepositoryImpl({IUserDatasource? userDatasource})
    : userDatasource = userDatasource ?? UserDatasourceImpl();

  @override
  Future<User> editUser(User user) {
    return userDatasource.editUser(user);
  }
}
