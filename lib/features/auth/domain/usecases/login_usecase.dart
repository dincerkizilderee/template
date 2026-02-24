import 'package:injectable/injectable.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  ResultFuture<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
