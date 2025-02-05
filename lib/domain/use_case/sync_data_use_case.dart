import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:sample_app/core/utils/file_utils.dart';

import '../../core/index.dart';
import '../../core/persistence/csv_storage.dart';
import '../../data/model/land_certificate_model.dart';
import '../../data/repository/csv_land_certificate_repository.dart';
import '../../logger/logger.dart';
import '../index.dart';

@injectable
class UploadDataUseCase extends FutureUseCase<bool, void> {
  UploadDataUseCase(this.driveRepository);

  final DriveRepository driveRepository;

  @override
  Future<bool> execute(void input) async {
    try {
      final path = await getFilePath(StorageInformation.fileName);
      final file = File(path);
      await driveRepository.uploadFile(file);
      return true;
    } catch (e) {
      logger.e("Lỗi upload dữ liệu: $e");
    }
    return false;
  }
}

@injectable
class StorageDataUseCase extends FutureUseCase<void, File> {
  StorageDataUseCase(this._simpleNotifier);

  final SimpleNotifier _simpleNotifier;

  @override
  Future<void> execute(File input) async {
    try {
      final rows = await readCsvRow(input);

      await writeCsvFile(StorageInformation.fileName, rows);

      // _simpleNotifier.notify();
    } catch (e) {
      logger.e("Lỗi lưu dữ liệu: $e");
    }
  }
}

@injectable
class SyncDataUseCase extends FutureUseCase<void, void> {
  SyncDataUseCase(
    this._driveRepository,
    this._storageDataUseCase,
    this._uploadDataUseCase,
  );

  final DriveRepository _driveRepository;
  final StorageDataUseCase _storageDataUseCase;
  final UploadDataUseCase _uploadDataUseCase;

  @override
  Future<void> execute(void input) async {
    try {
      //load file from drive
      final file = await _driveRepository.getFile();
      final remoteRows = await readCsvRow(file);
      final List<LandCertificateModel> remoteCers =
          remoteRows.sublist(1).map((e) => MappingRowToModel().from(e)).toList();

      //load file from local
      final path = await getFilePath(StorageInformation.fileName);
      final localFile = File(path);
      final rows = await readCsvRow(localFile);
      final List<LandCertificateModel> localCers = rows.sublist(1).map((e) => MappingRowToModel().from(e)).toList();

      //compare two files

      final mergeRows = MergeTwoFiles(
        local: localCers,
        remote: remoteCers,
        localLastedChanged: getModifiedTime(localFile),
        remoteLastedChanged: (await _driveRepository.getLastModifiedTime()) ?? DateTime.now(),
      ).merge();

      print('mergeRows: ${mergeRows.length}');

      await writeCsvFile(StorageInformation.fileName, [
        StorageInformation.header,
        ...mergeRows.map((e) => MappingToRow().from(e)),
      ]);

      await _uploadDataUseCase.execute(input);
    } catch (e) {
      logger.e("Lỗi đồng bộ dữ liệu: $e");
    }
  }
}

class MergeTwoFiles {
  final List<LandCertificateModel> local;
  final List<LandCertificateModel> remote;
  final DateTime localLastedChanged;
  final DateTime remoteLastedChanged;

  const MergeTwoFiles({
    required this.local,
    required this.remote,
    required this.localLastedChanged,
    required this.remoteLastedChanged,
  });

  List<LandCertificateModel> merge() {
    print('local localLastedChanged: ${localLastedChanged.toIso8601String()}');
    print('remote remoteLastedChanged: ${remoteLastedChanged.toIso8601String()}');

    final result = <LandCertificateModel>[];
    final Map<String, LandCertificateModel> localMap = {for (var item in local) item.cerId!: item};
    final Map<String, LandCertificateModel> remoteMap = {for (var item in remote) item.cerId!: item};

    // 1️⃣ Merge items with the same ID, choosing the newest one
    for (var id in localMap.keys) {
      if (remoteMap.containsKey(id)) {
        // If both exist, choose the latest one
        if (localMap[id]!.updatedAt!.isAfter(remoteMap[id]!.updatedAt!)) {
          result.add(localMap[id]!);
        } else {
          result.add(remoteMap[id]!);
        }
        remoteMap.remove(id); // Remove from remote to prevent duplicate processing
      }
    }

    // 2️⃣ Handle local-only records
    for (var id in localMap.keys) {
      if (!remoteMap.containsKey(id)) {
        if (localMap[id]!.updatedAt!.isAfter(remoteLastedChanged)) {
          result.add(localMap[id]!);
        }
      }
    }

    // 3️⃣ Handle remote-only records
    for (var id in remoteMap.keys) {
      if (remoteMap[id]!.updatedAt!.isAfter(localLastedChanged)) {
        result.add(remoteMap[id]!);
      }
    }

    return result;
  }
}
