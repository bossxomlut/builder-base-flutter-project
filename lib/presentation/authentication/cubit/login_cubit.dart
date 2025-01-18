import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repository/authentication_repository.dart';
import '../../utils/index.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> with SafeEmit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState.init());

  final AuthenticationRepository _authenticationRepository;

  Future<dynamic> login() {
    emit(const LoginState.loading());
    return _authenticationRepository.login().then(
      (dynamic result) {
        emit(const LoginState.success());
      },
    );
  }
}
