import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/src/auth_client.dart';
import 'package:injectable/injectable.dart';

import '../../domain/index.dart';

@Singleton(as: GoogleRepository)
class GoogleRepositoryImpl extends GoogleRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveFileScope, // Quyền truy cập Google Drive
    ],
  );

  @override
  Future<bool> login() async {
    try {
      //check is signed in
      if (await isLogin) {
        print("Đã đăng nhập!");
        return true;
      }

      // Đăng nhập Google
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        // Lấy AuthClient từ GoogleSignIn
        // final authClient = await _googleSignIn.authenticatedClient();
        return true;
      }
    } catch (e) {
      print("Lỗi đăng nhập: $e");
    }
    return false;
  }

  @override
  Future<AuthClient?> get authClient => _googleSignIn.authenticatedClient();

  @override
  Future<void> logout() {
    return _googleSignIn.signOut();
  }

  @override
  Future<bool> get isLogin async {
    final isLogin = await _googleSignIn.isSignedIn();
    if (isLogin) {
      if (_googleSignIn.currentUser == null) {
        await _googleSignIn.signInSilently();
      }
    }
    return isLogin;
  }
}

@Singleton(as: DriveRepository)
class DriveRepositoryImpl extends DriveRepository {
  final GoogleRepository _googleRepository;

  Future<drive.DriveApi?> get _driveApi =>
      _googleRepository.authClient.then((e) => e == null ? null : drive.DriveApi(e!));

  DriveRepositoryImpl(this._googleRepository);

  @override
  Future<void> uploadFile(File file) async {
    try {
      final _driveApi = (await this._driveApi)!;
      final driveFile = drive.File();
      driveFile.name = 'sổ_đỏ.csv';

      final media = drive.Media(file.openRead(), file.lengthSync());

      // 1. **Get or Create Folder**
      String? folderId = await _getOrCreateFolder('sổ_đỏ');
      if (folderId == null) {
        print("Không thể tạo hoặc tìm thấy thư mục.");
        return;
      }

      // 2. **Check if the file already exists**
      final existingFile = await _findFileInFolder('sổ_đỏ.csv', folderId);
      if (existingFile != null) {
        // **Update file without modifying parents**
        final updatedFile = await _driveApi.files.update(
          driveFile,
          existingFile.id!,
          uploadMedia: media,
        );
        print('File đã cập nhật thành công với ID: ${updatedFile.id}');
        return;
      }

      // 3. **Upload new file**
      driveFile.parents = [folderId]; // Only for new files
      final uploadedFile = await _driveApi.files.create(driveFile, uploadMedia: media);
      print('File CSV đã tải lên với ID: ${uploadedFile.id}');
    } catch (e) {
      print("Lỗi khi tải file CSV lên: $e");
    }
  }

  /// **Get or Create Folder**
  Future<String?> _getOrCreateFolder(String folderName) async {
    try {
      final _driveApi = (await this._driveApi)!;

      final drive.FileList folderList = await _driveApi.files.list(
        q: "name='$folderName' and mimeType='application/vnd.google-apps.folder' and trashed=false",
        spaces: 'drive',
      );

      if (folderList.files != null && folderList.files!.isNotEmpty) {
        return folderList.files!.first.id;
      }

      // Create folder if not found
      final folder = drive.File();
      folder.name = folderName;
      folder.mimeType = 'application/vnd.google-apps.folder';

      final createdFolder = await _driveApi.files.create(folder);
      return createdFolder.id;
    } catch (e) {
      print("Lỗi khi tạo hoặc tìm thư mục: $e");
      return null;
    }
  }

  /// **Check if file exists in folder**
  Future<drive.File?> _findFileInFolder(String fileName, String folderId) async {
    try {
      final _driveApi = (await this._driveApi)!;

      final drive.FileList fileList = await _driveApi.files.list(
        q: "name='$fileName' and '$folderId' in parents and trashed=false",
        spaces: 'drive',
      );

      return fileList.files?.isNotEmpty == true ? fileList.files!.first : null;
    } catch (e) {
      print("Lỗi khi tìm tệp trong thư mục: $e");
      return null;
    }
  }
}
