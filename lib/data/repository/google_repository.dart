import 'dart:developer';
import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/src/auth_client.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/stream_utils.dart';
import '../../domain/index.dart';

@Singleton(as: GoogleRepository)
class GoogleRepositoryImpl extends GoogleRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveScope, // Quyền truy cập Google Drive
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
    } catch (e, st) {
      //log stacktrace
      log('Lỗi khi tải file CSV lên', error: e, stackTrace: st);
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
        q: "name='$fileName' and ('$folderId' in parents or sharedWithMe=true  or 'your-service-account-email' in owners) and trashed=false",
        spaces: 'drive',
      );
      print('Tìm thấy ${fileList.files?.map((e) => e.name).join('|')} tệp trong thư mục.');

      return fileList.files?.isNotEmpty == true ? fileList.files!.first : null;
    } catch (e) {
      print("Lỗi khi tìm tệp trong thư mục: $e");
      return null;
    }
  }

  /// Tải file về thiết bị
  Future<File> _downloadFile(String fileId, String fileName) async {
    try {
      drive.Media fileMedia =
          await (await _driveApi)!.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

      List<int> dataStore = await fileMedia.stream.toFuture();

      log('📁 Downloaded file data: ${dataStore} ');

      final dir = await getTemporaryDirectory();

      final tempPath = Directory('${dir.path}/temporary');

      // Create the directory if it doesn't exist
      if (!tempPath.existsSync()) {
        tempPath.createSync(recursive: true);
      }

      File localFile = File('${tempPath.path}/$fileName');

      await localFile.writeAsBytes(dataStore);

      return localFile;
    } catch (e, st) {
      throw Exception("Lỗi khi tải xuống file: $e");
    }
  }

  @override
  Future<DateTime?> getLastModifiedTime() async {
    try {
      // 1. **Tìm hoặc tạo thư mục**
      String? folderId = await _getOrCreateFolder('sổ_đỏ');
      if (folderId == null) {
        print("Không thể tạo hoặc tìm thấy thư mục.");
        throw NotFoundException();
      }

      // 2. **Kiểm tra file**
      final existingFile = await _findFileInFolder('sổ_đỏ.csv', folderId);
      if (existingFile != null && existingFile.id != null) {
        // final file = (await (await _driveApi)!.files.get(existingFile.id!) as drive.File);
        final drive.File file = (await (await _driveApi)!.files.get(
              existingFile.id!,
              $fields: "id, name, createdTime", // Lấy thời gian tải lên
            ) as drive.File);

        return file.createdTime?.toLocal();
      }
    } catch (e, st) {
      print("❌ Error getting last modified time: $e");
      log('Error getting last modified time', error: e, stackTrace: st);
    }
    return null;
  }

  /// Lấy file từ Google Drive (tạo nếu chưa có)
  @override
  Future<File> getFile() async {
    try {
      // 1. **Tìm hoặc tạo thư mục**
      String? folderId = await _getOrCreateFolder('sổ_đỏ');
      if (folderId == null) {
        print("Không thể tạo hoặc tìm thấy thư mục.");
        throw NotFoundException();
      }

      // 2. **Kiểm tra file**
      final existingFile = await _findFileInFolder('sổ_đỏ.csv', folderId);
      if (existingFile != null && existingFile.id != null) {
        return await _downloadFile(existingFile.id!, 'sổ_đỏ.csv');
      }

      print("Không tìm thấy file trên Drive.");
      throw NotFoundException();
    } catch (e, st) {
      print('Lỗi khi tải file CSV về: $e');
      print(st);
      throw NotFoundException();
    }
  }
}
