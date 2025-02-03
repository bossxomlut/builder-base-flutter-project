import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../core/index.dart';
import '../../domain/index.dart';
import '../../resource/index.dart';
import '../model/land_certificate_model.dart';
import '../model/province_model.dart';
import 'isar_repository.dart';

@Injectable(as: LandCertificateRepository)
class LandCertificateRepositoryImpl extends LandCertificateRepository
    with IsarCrudRepository<LandCertificateEntity, LandCertificateModel> {
  LandCertificateRepositoryImpl(this._landCertificateMapping);

  final Isar _isar = Isar.getInstance()!;
  final LandCertificateMapping _landCertificateMapping;

  @override
  IsarCollection<LandCertificateModel> get collection => _isar.landCertificateModels;

  @override
  LandCertificateModel createNewItem(LandCertificateEntity item) {
    return LandCertificateModelMapping().from(item);
  }

  @override
  Future<List<LandCertificateEntity>> getAll() {
    return collection.where().findAll().then((collections) {
      return mapListAsync(collections, getItemFromCollection);
    });
  }

  @override
  Future<LandCertificateEntity> getItemFromCollection(LandCertificateModel collection) {
    return _landCertificateMapping.from(collection);
  }

  @override
  Isar get isar => _isar;

  @override
  Future<List<LandCertificateEntity>> search(String keyword) {
    return collection.where().filter().nameContains(keyword).findAll().then((collections) {
      return mapListAsync(collections, getItemFromCollection);
    });
  }

  @override
  LandCertificateModel updateNewItem(LandCertificateEntity item) {
    return createNewItem(item)..id = item.id!;
  }

  @override
  Future<List<LandCertificateEntity>> searchByDistrict(DistrictEntity district, String keyword) {
    return collection.filter().districtEqualTo(district.name).findAll().then((collections) {
      return mapListAsync(collections, getItemFromCollection);
    });
  }

  @override
  Future<List<LandCertificateEntity>> searchByProvince(ProvinceEntity province, String keyword) {
    return collection.filter().provinceEqualTo(province.name).findAll().then((collections) {
      return mapListAsync(collections, getItemFromCollection);
    });
  }

  @override
  Future<List<LandCertificateEntity>> searchByWard(WardEntity ward, String keyword) {
    return collection.filter().wardEqualTo(ward.name).findAll().then((collections) {
      return mapListAsync(collections, getItemFromCollection);
    });
  }
}

@Injectable(as: LandCertificateObserverData)
class LandCertificateObserverDataImpl extends LandCertificateObserverData {
  final Isar _isar = Isar.getInstance()!;

  @override
  void listener(Function(void value) callback) {
    if (subscription == null) {
      setSubscription(
        _isar.landCertificateModels.watchLazy(fireImmediately: false).listen(callback),
      );
    } else {
      //todo:
    }
  }
}

@Injectable(as: ProvinceLandCertificateRepository)
class ProvinceLandCertificateRepositoryImpl extends ProvinceLandCertificateRepository {
  ProvinceLandCertificateRepositoryImpl(this._landCertificateMapping);

  final Isar _isar = Isar.getInstance()!;

  IsarCollection<LandCertificateModel> get lCollection => _isar.landCertificateModels;

  IsarCollection<ProvinceModel> get pCollection => _isar.provinceModels;

  final LandCertificateMapping _landCertificateMapping;

  @override
  Future<List<ProvinceLandCertificateEntity>> getAll() async {
    final List<ProvinceModel> provinces = pCollection.where().findAllSync();

    List<ProvinceLandCertificateEntity> result = [];

    for (var province in provinces) {
      final List<LandCertificateModel> landCertificates =
          lCollection.where().filter().provinceEqualTo(province.name).findAllSync();
      if (landCertificates.isEmpty) continue;

      result.add(
        ProvinceLandCertificateEntity(
          id: province.id,
          name: province.name,
          certificates: await mapListAsync(landCertificates, (e) => _landCertificateMapping.from(e)),
          // certificates: landCertificates.map((e) => LandCertificateRepositoryImpl().getItemFromCollection(e)).toList(),
        ),
      );
    }

    final List<LandCertificateModel> landCertificates =
        lCollection.where().filter().provinceIsNull().and().districtIsNull().and().wardIsNull().findAllSync();
    if (landCertificates.isNotEmpty) {
      result.add(
        ProvinceLandCertificateEntity(
          id: -1,
          name: LKey.other.tr(),
          certificates: await mapListAsync(landCertificates, (e) => _landCertificateMapping.from(e)),
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
