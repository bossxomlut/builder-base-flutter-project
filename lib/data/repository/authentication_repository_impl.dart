import 'package:injectable/injectable.dart';

import '../../domain/repository/authentication_repository.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl();

  @override
  Future login() async {}
}
