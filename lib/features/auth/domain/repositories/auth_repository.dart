import '../../../../core/utils/typedefs.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  ResultFuture<User> login(String email, String password);
}
