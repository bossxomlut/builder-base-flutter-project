import 'dart:async';
import 'dart:developer';
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
class CheckInitialDataUseCase extends FutureUseCase<void, void> {
  CheckInitialDataUseCase(this._downloadDataUseCase);

  final DownloadDataUseCase _downloadDataUseCase;

  @override
  Future<void> execute(void input) async {
    final isExistsFile = await checkFileExists(StorageInformation.fileName);

    if (isExistsFile) {
      return;
    }

    await _downloadDataUseCase.execute(input);
  }
}

@injectable
class DownloadDataUseCase extends FutureUseCase<void, void> {
  DownloadDataUseCase(this.driveRepository, this.storageDataUseCase);

  final DriveRepository driveRepository;
  final StorageDataUseCase storageDataUseCase;

  @override
  Future<void> execute(void input) async {
    try {
      final file = await driveRepository.getFile();
      await storageDataUseCase.execute(file);
    } catch (e) {
      logger.e("Lỗi tải dữ liệu: $e");
    }
  }
}

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

@singleton
class ScheduleUploadDataUseCase extends FutureUseCase<void, void> {
  ScheduleUploadDataUseCase(this._uploadDataUseCase, this._syncDataUseCase);

  final UploadDataUseCase _uploadDataUseCase;
  final SyncDataUseCase _syncDataUseCase;

  Duration _duration = const Duration(minutes: 5);

  void setDurationAndReSchedule(Duration duration) {
    _duration = duration;
    cancel();
    execute(null);
  }

  bool isRunning = false;

  Timer? _timer;

  //storage last time upload
  DateTime? _lastTimeUpload;

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _lastTimeUpload = null;
  }

  @override
  Future<void> execute(void input) async {
    _timer = Timer.periodic(
      _duration,
      (timer) async {
        try {
          if (isRunning) {
            return;
          }

          //get date time modified of current local file
          final path = await getFilePath(StorageInformation.fileName);
          final file = File(path);
          final lastTimeModified = getModifiedTime(file);

          //check if file is modified
          if (_lastTimeUpload != null && lastTimeModified.isBefore(_lastTimeUpload!)) {
            return;
          }

          isRunning = true;
          final rs = await _syncDataUseCase.execute(null);

          if (rs) {
            _lastTimeUpload = DateTime.now();
            logger.i("Sync dữ liệu thành công");
          } else {
            logger.i("Lỗi Sync dữ liệu");
          }
          //cancel timer
          isRunning = false;
        } catch (e) {
          isRunning = false;
          logger.e("Lỗi Sync dữ liệu: $e");
        }
      },
    );
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

      //check file exists
      final isExistsFile = await checkFileExists(StorageInformation.fileName);
      if (!isExistsFile) {
        await createFile(StorageInformation.fileName);
      }

      await writeCsvFile(StorageInformation.fileName, rows);

      _simpleNotifier.notify();
    } catch (e, stackTrace) {
      log('Lỗi lưu dữ liệu: $e', stackTrace: stackTrace);
      logger.e("Lỗi lưu dữ liệu: $e");
    }
  }
}

@injectable
class SyncDataUseCase extends FutureUseCase<bool, void> {
  SyncDataUseCase(
    this._driveRepository,
    this._storageDataUseCase,
    this._uploadDataUseCase,
  );

  final DriveRepository _driveRepository;
  final StorageDataUseCase _storageDataUseCase;
  final UploadDataUseCase _uploadDataUseCase;

  @override
  Future<bool> execute(void input) async {
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

      await _uploadDataUseCase.execute(null);
      return true;
    } catch (e) {
      logger.e("Lỗi đồng bộ dữ liệu: $e");
      if (e is NotFoundException) {
        await _uploadDataUseCase.execute(null);
      }
    }

    return false;
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
    final Set<String> processedIds = {};

    // 1️⃣ Merge items with the same ID, choosing the newest one
    for (var id in localMap.keys) {
      if (remoteMap.containsKey(id)) {
        // If both exist, choose the latest one
        if (localMap[id]!.updatedAt!.isAfter(remoteMap[id]!.updatedAt!)) {
          result.add(localMap[id]!);
        } else {
          result.add(remoteMap[id]!);
        }
        processedIds.add(id);
      }
    }

    //remove processedIds in remote and local maps
    for (var id in processedIds) {
      localMap.remove(id);
      remoteMap.remove(id);
    }

    // 2️⃣ Handle local-only records
    for (var id in localMap.keys) {
      result.add(localMap[id]!);
    }

    // 3️⃣ Handle remote-only records
    for (var id in remoteMap.keys) {
      result.add(remoteMap[id]!);
    }

    logger.i('Merge result: ${result.length} records');

    return result;
  }
}
