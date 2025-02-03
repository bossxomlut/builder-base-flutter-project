import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../core/index.dart';
import '../../core/persistence/csv_storage.dart';
import '../../core/utils/id_utils.dart';
import '../../domain/index.dart';
import '../../resource/index.dart';
import '../model/land_certificate_model.dart';
import '../model/province_model.dart';

abstract class StorageInformation {
  static const String fileName = 'sổ_đỏ.csv';

  static const List<String> header = [
    'id',
    'Tên',
    'Tỉnh/Thành phố',
    'Quận/Huyện',
    'Phường/Xã',
    'Địa chỉ chi tiết',
    'Ngày mua',
    'Giá mua',
    'Ngày bán',
    'Giá bán',
    'Số thửa đất',
    'Số bản đồ',
    'Diện tích',
    'Hình thức sử dụng',
    'Mục đích sử dụng',
    'Thời gian sử dụng',
    'Đất ở',
    'Diện tích cây lâu năm',
    'Thời điểm đóng thuế',
    'Thời điểm gia hạn thuế',
    'Ghi chú',
    'Danh sách tệp tin',
    'Thời điểm cập nhật',
  ];
}

@singleton
class SimpleNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  void notify() {
    _controller.add(null);
  }

  void addListener(Function(void value) callback) {
    _controller.stream.listen(callback);
  }
}

@Injectable(as: LandCertificateRepository)
class LandCertificateRepositoryCSVImpl extends LandCertificateRepository {
  LandCertificateRepositoryCSVImpl(
      this._landCertificateMapping, this._certificateModelMapping, this._mappingToRow, this._notifier);

  final LandCertificateMapping _landCertificateMapping;
  final LandCertificateModelMapping _certificateModelMapping;
  final MappingToRow _mappingToRow;
  final SimpleNotifier _notifier;

  @override
  Future<LandCertificateEntity> create(LandCertificateEntity item) async {
    final cerId = generateShortUuid();

    final LandCertificateModel model = _certificateModelMapping.from(
      item.copyWith(cerId: cerId),
    )..updatedAt = DateTime.now();
    final row = _mappingToRow.from(model);

    await appendCsvRecord(StorageInformation.fileName, row, header: StorageInformation.header);
    _notifier.notify();
    return _landCertificateMapping.from(model);
  }

  @override
  Future<bool> delete(LandCertificateEntity item) async {
    return true;
  }

  @override
  Future<List<LandCertificateEntity>> getAll() async {
    return [];
  }

  @override
  Future<LandCertificateEntity> read(int id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<LandCertificateEntity>> search(String keyword) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<List<LandCertificateEntity>> searchByDistrict(DistrictEntity district, String keyword) {
    // TODO: implement searchByDistrict
    throw UnimplementedError();
  }

  @override
  Future<List<LandCertificateEntity>> searchByProvince(ProvinceEntity province, String keyword) {
    // TODO: implement searchByProvince
    throw UnimplementedError();
  }

  @override
  Future<List<LandCertificateEntity>> searchByWard(WardEntity ward, String keyword) {
    // TODO: implement searchByWard
    throw UnimplementedError();
  }

  @override
  Future<LandCertificateEntity> update(LandCertificateEntity item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

@Injectable(as: LandCertificateObserverData)
class LandCertificateObserverDataImpl extends LandCertificateObserverData {
  LandCertificateObserverDataImpl(this._notifier);

  final SimpleNotifier _notifier;

  @override
  void listener(Function(void value) callback) {
    _notifier.addListener(callback);
  }
}

@Injectable(as: ProvinceLandCertificateRepository)
class ProvinceLandCertificateRepositoryImpl extends ProvinceLandCertificateRepository {
  ProvinceLandCertificateRepositoryImpl(
      this._landCertificateMapping, this._mappingRowToModel, this._provinceRepository);

  final LandCertificateMapping _landCertificateMapping;
  final MappingRowToModel _mappingRowToModel;
  final ProvinceRepository _provinceRepository;

  @override
  Future<List<ProvinceLandCertificateEntity>> getAll() async {
    final rows = await readCsvFile(StorageInformation.fileName);
    final List<LandCertificateModel> certificates = rows.sublist(1).map((e) => _mappingRowToModel.from(e)).toList();

    print('certificates: $certificates');

    List<ProvinceLandCertificateEntity> result = [];
    Map<ProvinceEntity, List<LandCertificateEntity>> map = {};

    for (var cer in certificates) {
      final provinceName = cer.province;
      print('provinceName: $provinceName');

      final provinceEntity =
          (provinceName.isNotNullOrEmpty ? await _provinceRepository.getOneByName(provinceName!) : null) ??
              ProvinceEntity(
                id: -1,
                name: LKey.other.tr(),
              );
      final cerEntity = await _landCertificateMapping.from(cer);

      if (map.containsKey(provinceEntity)) {
        map[provinceEntity]!.add(cerEntity);
      } else {
        map[provinceEntity] = [cerEntity];
      }
    }

    for (var entry in map.entries) {
      result.add(
        ProvinceLandCertificateEntity(
          id: entry.key.id,
          name: entry.key.name ?? '',
          certificates: entry.value,
        ),
      );
    }

    return result;
  }

  @override
  Future<List<ProvinceLandCertificateEntity>> search(String keyword) {
    return getAll();
  }
}

@Injectable(as: SearchGroupCertificateRepository)
class SearchGroupCertificateRepositoryImpl extends SearchGroupCertificateRepository {
  SearchGroupCertificateRepositoryImpl(this._districtRepository);

  final Isar _isar = Isar.getInstance()!;
  IsarCollection<ProvinceModel> get pCollection => _isar.provinceModels;

  IsarCollection<LandCertificateModel> get lCollection => _isar.landCertificateModels;

  final DistrictRepository _districtRepository;

  @override
  Future<List<ProvinceCountEntity>> getAll() async {
    final List<ProvinceModel> provinces = pCollection.where().findAllSync();
    provinces.addAll([
      ProvinceModel()
        ..id = -1
        ..name = LKey.other.tr(),
    ]);

    return _get(provinces);
  }

  @override
  Future<List<ProvinceCountEntity>> search(String keyword) {
    if (keyword.isEmpty) {
      return getAll();
    }

    final List<ProvinceModel> provinces = pCollection.filter().nameContains(keyword).findAllSync();

    return _get(provinces);
  }

  @override
  Future<List<ProvinceCountEntity>> _get(List<ProvinceModel> provinces) async {
    List<ProvinceCountEntity> result = [];

    for (var province in provinces) {
      final lands = lCollection.where().filter().provinceEqualTo(province.name).findAllSync();
      final count = lands.length;

      if (count == 0) continue;

      Map<DistrictEntity, DistrictCountEntity> districtMap = {};

      for (var land in lands) {
        // final combineId = land.combineAddressId;
        // List<int> addressIds = ProvinceUtil.getIds(combineId ?? '');
        // List<String> addressNames = ProvinceUtil.getNames(land.combineAddressName ?? '');
        //
        // final districtId = addressIds.elementAt(1);
        // final districtName = addressNames.elementAt(1);

        final districtName = land.district;
        final DistrictEntity district =
            (districtName.isNotNullOrEmpty ? await _districtRepository.getOneByName(districtName!) : null) ??
                DistrictEntity(
                  id: -1,
                  provinceId: province.id,
                  name: LKey.other.tr(),
                );

        if (districtMap.containsKey(district)) {
          districtMap[district] = districtMap[district]!.copyWith(total: districtMap[district]!.total + 1);
        } else {
          districtMap[district] = DistrictCountEntity(
            id: district.id,
            name: district.name,
            total: 1,
          );
        }
      }

      result.add(
        ProvinceCountEntity(
          id: province.id,
          name: province.name ?? '',
          total: count,
          districts: districtMap.values.toList(),
        ),
      );
    }

    return result;
  }
}
