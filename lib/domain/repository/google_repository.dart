import 'dart:io';

import 'package:googleapis_auth/googleapis_auth.dart' as gapis;

abstract class GoogleRepository {
  Future<void> login();

  Future<void> logout();

  gapis.AuthClient get authClient;
}

abstract class DriveRepository {
  Future<void> uploadFile(File file);
}
