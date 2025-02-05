import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../core/index.dart';
import '../index.dart';

@injectable
class CheckGoogleLoginUseCase extends FutureUseCase<bool, void> {
  CheckGoogleLoginUseCase(this._repository);

  final GoogleRepository _repository;

  @override
  Future<bool> execute(void input) {
    return _repository.isLogin;
  }
}

@injectable
class GoogleLoginUseCase extends FutureUseCase<bool, void> {
  GoogleLoginUseCase(this._repository);

  final GoogleRepository _repository;

  @override
  Future<bool> execute(void input) async {
    return _repository.login();
  }
}

@injectable
class GoogleLogoutUseCase extends FutureUseCase<void, void> {
  GoogleLogoutUseCase(this._repository);

  final GoogleRepository _repository;

  @override
  Future<void> execute(void input) async {
    final rs = await _repository.logout();
  }
}

@injectable
class UploadFileUseCase extends FutureUseCase<void, File> {
  UploadFileUseCase(this._repository);

  final DriveRepository _repository;

  @override
  Future<void> execute(File input) async {
    final rs = await _repository.uploadFile(input);
  }
}
