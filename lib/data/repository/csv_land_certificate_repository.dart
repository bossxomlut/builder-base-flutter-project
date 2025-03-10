import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/index.dart';
import '../../core/persistence/csv_storage.dart';
import '../../core/utils/id_utils.dart';
import '../../core/utils/search_utils.dart';
import '../../domain/entity/filter_land_certificate_entity.dart';
import '../../domain/index.dart';
import '../../resource/index.dart';
import '../model/land_certificate_model.dart';

abstract class StorageInformation {
  static const String folder = 'sổ_đỏ';

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
    'Đã xoá',
    'Diện tích khác',
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
    this._landCertificateMapping,
    this._certificateModelMapping,
    this._mappingToRow,
    this._notifier,
    this._mappingRowToModel,
  );

  final LandCertificateMapping _landCertificateMapping;
  final LandCertificateModelMapping _certificateModelMapping;
  final MappingToRow _mappingToRow;
  final SimpleNotifier _notifier;
  final MappingRowToModel _mappingRowToModel;

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
    final existsItemIndex = await findIndexByCerId(item.cerId!);

    if (existsItemIndex == -1) {
      return false;
    }

    //item to model
    final model = _certificateModelMapping.from(item)
      ..isDeleted = true
      ..updatedAt = DateTime.now();

    await updateCsvRecord(
      StorageInformation.fileName,
      existsItemIndex,
      _mappingToRow.from(model),
    );
    _notifier.notify();
    return true;
  }

  @override
  Future<List<LandCertificateEntity>> getAll() async {
    try {
      final rows = await readCsvFile(StorageInformation.fileName);
      final List<LandCertificateModel> certificates =
          rows.sublist(1).map((e) => _mappingRowToModel.from(e)).where((e) => e.isDeleted != true).toList();

      return mapListAsync(certificates, _landCertificateMapping.from);
    } catch (e) {}
    return [];
  }

  @override
  Future<LandCertificateEntity> read(int id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<LandCertificateEntity>> search(String keyword) async {
    final rows = await getAll();
    final LandCertificateSearchBuilder searchBuilder = LandCertificateSearchBuilder();

    return rows.where((e) => searchBuilder.isMatch(e, keyword)).toList();
  }

  @override
  Future<List<LandCertificateEntity>> searchByDistrict(DistrictEntity district, String keyword) async {
    final rows = await getAll();

    return rows.where((element) {
      if (district.id == -1) {
        if (district.provinceId == -1) {
          return element.district == null && element.province == null;
        }

        return element.district == null && district.provinceId == element.province?.id;
      }

      return element.district?.name == district.name && district.provinceId == element.province?.id;
    }).toList();
  }

  @override
  Future<List<LandCertificateEntity>> searchByProvince(ProvinceEntity province, String keyword) async {
    final rows = await getAll();

    return rows.where((element) => element.province?.name == province.name).toList();
  }

  @override
  Future<List<LandCertificateEntity>> searchByWard(WardEntity ward, String keyword) async {
    final rows = await getAll();

    return rows.where((element) => element.ward?.name == ward.name).toList();
  }

  @override
  Future<LandCertificateEntity> update(LandCertificateEntity item) async {
    try {
      final existsItemIndex = await findIndexByCerId(item.cerId!);

      if (existsItemIndex == -1) {
        throw NotFoundException();
      }

      final LandCertificateModel model = _certificateModelMapping.from(item)..updatedAt = DateTime.now();

      //find index of exists ite

      await updateCsvRecord(
        StorageInformation.fileName,
        existsItemIndex,
        _mappingToRow.from(model),
      );
    } catch (e) {
      throw NotFoundException();
    }

    _notifier.notify();

    return item;
  }

  @override
  Future<LandCertificateEntity> readByCerId(String cerId) async {
    final rows = await readCsvFile(StorageInformation.fileName);
    final List<LandCertificateModel> certificates = rows.sublist(1).map((e) => _mappingRowToModel.from(e)).toList();

    final model = certificates.firstWhere((element) => element.cerId == cerId);
    return _landCertificateMapping.from(model);
  }

  @override
  Future<int> findIndexByCerId(String cerId) async {
    final rows = await readCsvFile(StorageInformation.fileName);
    final List<LandCertificateModel> certificates = rows.sublist(1).map((e) => _mappingRowToModel.from(e)).toList();
    final index = certificates.indexWhere((element) => element.cerId == cerId);
    return index == -1 ? -1 : index + 1;
  }

  @override
  Future<List<LandCertificateEntity>> searchAndFilter(String keyword, FilterLandCertificateEntity? filter) async {
    final rows = await getAll();
    final LandCertificateSearchComplexBuilder searchBuilder = LandCertificateSearchComplexBuilder();

    return rows
        .where((e) => searchBuilder.isMatch(e, {
              'keyword': keyword,
              'filter': filter,
            }))
        .toList();
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
    this._landCertificateMapping,
    this._mappingRowToModel,
    this._provinceRepository,
    this._landCertificateRepository,
  );

  final LandCertificateMapping _landCertificateMapping;
  final MappingRowToModel _mappingRowToModel;
  final ProvinceRepository _provinceRepository;
  final LandCertificateRepository _landCertificateRepository;

  @override
  Future<List<ProvinceLandCertificateEntity>> getAll() async {
    try {
      final List<LandCertificateEntity> certificates = await _landCertificateRepository.getAll();

      List<ProvinceLandCertificateEntity> result = [];
      Map<ProvinceEntity, List<LandCertificateEntity>> map = {};

      for (var cer in certificates) {
        final province = cer.province;

        final provinceEntity = province ??
            ProvinceEntity(
              id: -1,
              name: LKey.other.tr(),
            );

        if (map.containsKey(provinceEntity)) {
          map[provinceEntity]!.add(cer);
        } else {
          map[provinceEntity] = [cer];
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
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ProvinceLandCertificateEntity>> search(String keyword) {
    return getAll();
  }
}

@Injectable(as: SearchGroupCertificateRepository)
class SearchGroupCertificateRepositoryImpl extends SearchGroupCertificateRepository {
  SearchGroupCertificateRepositoryImpl(this._districtRepository, this._landCertificateRepository);

  final DistrictRepository _districtRepository;
  final LandCertificateRepository _landCertificateRepository;
  @override
  Future<List<ProvinceCountEntity>> getAll() async {
    final allRows = await _landCertificateRepository.getAll();

    return _fromLandCerList(allRows);
  }

  Future<List<ProvinceCountEntity>> _fromLandCerList(List<LandCertificateEntity> allRows) async {
    Map<ProvinceEntity, int> map = {};
    Map<ProvinceEntity, List<DistrictCountEntity>> districtMap = {};

    for (var row in allRows) {
      final province = row.province ??
          ProvinceEntity(
            id: -1,
            name: LKey.other.tr(),
          );

      final district = row.district ??
          DistrictEntity(
            id: -1,
            provinceId: province.id,
            name: LKey.other.tr(),
          );

      if (map.containsKey(province)) {
        map[province] = map[province]! + 1;
        //set district count
        final set = districtMap[province]!;
        final index = set.indexWhere((element) => element.id == district.id);
        if (index != -1) {
          set[index] = set[index].copyWith(total: set[index].total + 1);
        } else {
          set.add(
            DistrictCountEntity(
              id: district.id,
              name: district.name,
              total: 1,
            ),
          );
        }
      } else {
        map[province] = 1;
        districtMap[province] = [
          DistrictCountEntity(
            id: district.id,
            name: district.name,
            total: 1,
          ),
        ];
      }
    }

    return map.entries
        .map((e) => ProvinceCountEntity(
              id: e.key.id,
              name: e.key.name,
              total: e.value,
              districts: districtMap[e.key] ?? [],
            ))
        .toList();
  }

  @override
  Future<List<ProvinceCountEntity>> search(String keyword) async {
    final allRows = await _landCertificateRepository.search(keyword);
    return _fromLandCerList(allRows);
  }

  @override
  Future<List<ProvinceCountEntity>> searchAndFilter(String keyword, FilterLandCertificateEntity? filter) {
    return _landCertificateRepository.searchAndFilter(keyword, filter).then(_fromLandCerList);
  }
}

class LandCertificateSearchBuilder extends SearchBuilder<LandCertificateEntity> {
  @override
  bool isMatch(LandCertificateEntity item, String keyword) {
    final lowerKeyword = keyword.toLowerCase();

    return [
      item.name,
      item.province?.name,
      item.district?.name,
      item.ward?.name,
      item.detailAddress,
      item.note,
      item.useType,
      item.purpose,
    ].any((value) => value?.toLowerCase().contains(lowerKeyword) ?? false);
  }
}

class FilterLandCertificateSearchBuilder
    extends SearchBuilderByInput<LandCertificateEntity, FilterLandCertificateEntity> {
  @override
  bool isMatch(LandCertificateEntity entity, FilterLandCertificateEntity input) {
    // 🗓️ Tìm kiếm theo ngày mua
    if (input.purchaseDateFrom != null &&
        (entity.purchaseDate == null || entity.purchaseDate!.isBefore(input.purchaseDateFrom!))) {
      return false;
    }
    if (input.purchaseDateTo != null &&
        (entity.purchaseDate == null || entity.purchaseDate!.isAfter(input.purchaseDateTo!))) {
      return false;
    }

    // 🗓️ Tìm kiếm theo ngày bán
    if (input.saleDateFrom != null && (entity.saleDate == null || entity.saleDate!.isBefore(input.saleDateFrom!))) {
      return false;
    }
    if (input.saleDateTo != null && (entity.saleDate == null || entity.saleDate!.isAfter(input.saleDateTo!))) {
      return false;
    }

    // 💰 Tìm kiếm theo giá mua
    if (input.purchasePriceFrom != null &&
        (entity.purchasePrice == null || entity.purchasePrice! < input.purchasePriceFrom!)) {
      return false;
    }
    if (input.purchasePriceTo != null &&
        (entity.purchasePrice == null || entity.purchasePrice! > input.purchasePriceTo!)) {
      return false;
    }

    // 💰 Tìm kiếm theo giá bán
    if (input.salePriceFrom != null && (entity.salePrice == null || entity.salePrice! < input.salePriceFrom!)) {
      return false;
    }
    if (input.salePriceTo != null && (entity.salePrice == null || entity.salePrice! > input.salePriceTo!)) {
      return false;
    }

    // 📏 Tìm kiếm theo diện tích
    if (input.areaFrom != null && (entity.totalAllArea < input.areaFrom!)) {
      return false;
    }
    if (input.areaTo != null && (entity.totalAllArea > input.areaTo!)) {
      return false;
    }

    return true;
  }
}

class LandCertificateSearchComplexBuilder extends ComplexSearchBuilder<LandCertificateEntity> {
  final LandCertificateSearchBuilder _searchBuilder = LandCertificateSearchBuilder();
  final FilterLandCertificateSearchBuilder _filterSearchBuilder = FilterLandCertificateSearchBuilder();

  @override
  bool isMatch(LandCertificateEntity item, Map searchParams) {
    final keyword = searchParams['keyword'] as String;
    final FilterLandCertificateEntity? filter = searchParams['filter'] as FilterLandCertificateEntity?;

    if (filter == null) {
      return _searchBuilder.isMatch(item, keyword);
    }

    return _searchBuilder.isMatch(item, keyword) && _filterSearchBuilder.isMatch(item, filter);
  }
}
