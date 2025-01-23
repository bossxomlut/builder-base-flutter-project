import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/index.dart';
import '../../resource/index.dart';
import '../model/land_certificate_model.dart';
import '../model/province_model.dart';
import 'isar_repository.dart';

@Injectable(as: LandCertificateRepository)
class LandCertificateRepositoryImpl extends LandCertificateRepository
    with IsarCrudRepository<LandCertificateEntity, LandCertificateModel> {
  final Isar _isar = Isar.getInstance()!;

  @override
  IsarCollection<LandCertificateModel> get collection => _isar.landCertificateModels;

  @override
  LandCertificateModel createNewItem(LandCertificateEntity item) {
    return LandCertificateModelMapping().from(item);
  }

  @override
  Future<List<LandCertificateEntity>> getAll() {
    return collection.where().findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  LandCertificateEntity getItemFromCollection(LandCertificateModel collection) {
    return LandCertificateMapping().from(collection);
  }

  @override
  Isar get isar => _isar;

  @override
  Future<List<LandCertificateEntity>> search(String keyword) {
    return collection.where().filter().nameContains(keyword).findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  LandCertificateModel updateNewItem(LandCertificateEntity item) {
    return createNewItem(item)..id = item.id;
  }

  @override
  Future<List<LandCertificateEntity>> searchByDistrict(DistrictEntity district, String keyword) {
    return collection
        .filter()
        .combineAddressIdStartsWith('${district.provinceId}_${district.id}_')
        .findAll()
        .then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  Future<List<LandCertificateEntity>> searchByProvince(ProvinceEntity province, String keyword) {
    return collection.filter().combineAddressIdStartsWith('${province.id}_').findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  Future<List<LandCertificateEntity>> searchByWard(WardEntity ward, String keyword) {
    return collection.filter().combineAddressIdEndsWith('_${ward.districtId}_${ward.id}').findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }
}

@Injectable(as: ProvinceLandCertificateRepository)
class ProvinceLandCertificateRepositoryImpl extends ProvinceLandCertificateRepository {
  final Isar _isar = Isar.getInstance()!;

  IsarCollection<LandCertificateModel> get lCollection => _isar.landCertificateModels;

  IsarCollection<ProvinceModel> get pCollection => _isar.provinceModels;

  @override
  Future<List<ProvinceLandCertificateEntity>> getAll() async {
    final List<ProvinceModel> provinces = pCollection.where().findAllSync();

    List<ProvinceLandCertificateEntity> result = [];

    for (var province in provinces) {
      final List<LandCertificateModel> landCertificates =
          lCollection.where().filter().combineAddressIdStartsWith(province.id.toString() + '_').findAllSync();
      if (landCertificates.isEmpty) continue;

      result.add(
        ProvinceLandCertificateEntity(
          id: province.id,
          name: province.name,
          certificates: landCertificates.map((e) => LandCertificateRepositoryImpl().getItemFromCollection(e)).toList(),
        ),
      );
    }

    final List<LandCertificateModel> landCertificates =
        lCollection.where().filter().combineAddressIdIsNull().or().combineAddressIdStartsWith('-1').findAllSync();
    if (landCertificates.isNotEmpty) {
      result.add(
        ProvinceLandCertificateEntity(
          id: -1,
          name: LKey.other.tr(),
          certificates: landCertificates.map(LandCertificateMapping().from).toList(),
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
  final Isar _isar = Isar.getInstance()!;
  IsarCollection<ProvinceModel> get pCollection => _isar.provinceModels;

  IsarCollection<LandCertificateModel> get lCollection => _isar.landCertificateModels;

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
      final lands = lCollection.where().filter().combineAddressIdStartsWith(province.id.toString() + '_').findAllSync();
      final count = lands.length;

      if (count == 0) continue;

      Map<DistrictEntity, DistrictCountEntity> districtMap = {};

      for (var land in lands) {
        final combineId = land.combineAddressId;
        List<int> addressIds = ProvinceUtil.getIds(combineId ?? '');
        List<String> addressNames = ProvinceUtil.getNames(land.combineAddressName ?? '');

        final districtId = addressIds.elementAt(1);
        final districtName = addressNames.elementAt(1);

        final district = DistrictEntity(
          id: districtId,
          provinceId: province.id,
          name: districtId == -1 ? LKey.other.tr() : districtName,
        );

        if (districtMap.containsKey(district)) {
          districtMap[district] = districtMap[district]!.copyWith(total: districtMap[district]!.total + 1);
        } else {
          districtMap[district] = DistrictCountEntity(
            id: districtId,
            name: districtId == -1 ? LKey.other.tr() : districtName,
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
