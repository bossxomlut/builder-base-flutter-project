import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../core/persistence/file_storage.dart';
import '../index.dart';

@injectable
class CreateLandCertificateUseCase {
  final LandCertificateRepository _landCertificateRepository;

  CreateLandCertificateUseCase(this._landCertificateRepository);

  Future<void> execute(LandCertificateEntity landCertificate) async {
    List<AppFile> files = [];

    for (AppFile file in [...?landCertificate.files]) {
      final isLocalFile = await isInternalPath(file.path);
      if (isLocalFile) {
        files.add(file);
      } else {
        final localPath = await saveFileToLocalDirectory(File(file.path));
        files.add(file.copyWith(path: localPath));
      }
    }

    await _landCertificateRepository.create(landCertificate.copyWith(files: files));
  }
}
