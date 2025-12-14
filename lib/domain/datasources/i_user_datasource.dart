import 'package:smart_route_app/domain/domain.dart';

abstract class IUserDatasource {
  Future<User> editUser(User user);
}
