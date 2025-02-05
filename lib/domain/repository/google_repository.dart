import 'dart:io';

import 'package:googleapis_auth/googleapis_auth.dart' as gapis;

abstract class GoogleRepository {
  Future<bool> login();

  Future<void> logout();

  Future<gapis.AuthClient?> get authClient;

  Future<bool> get isLogin;
}

abstract class DriveRepository {
  Future<void> uploadFile(File file);

  Future<File> getFile();

  Future<DateTime?> getLastModifiedTime();
}
