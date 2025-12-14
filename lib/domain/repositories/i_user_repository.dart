import 'package:smart_route_app/domain/domain.dart';

abstract class IUserRepository {
  Future<User> editUser(User user);
}
