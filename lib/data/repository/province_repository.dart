import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/index.dart';
import '../model/province_model.dart';
import 'isar_repository.dart';

@Injectable(as: ProvinceRepository)
class ProvinceRepositoryImpl extends ProvinceRepository with IsarCrudRepository<ProvinceEntity, ProvinceModel> {
  final Isar _isar = Isar.getInstance()!;

  @override
  Isar get isar => _isar;

  @override
  IsarCollection<ProvinceModel> get collection => isar.provinceModels;

  @override
  ProvinceEntity getItemFromCollection(ProvinceModel collection) {
    return ProvinceEntity(
      id: collection.id,
      name: collection.name ?? '',
    );
  }

  @override
  ProvinceModel createNewItem(ProvinceEntity item) {
    return ProvinceModel()..name = item.name;
  }

  @override
  Future<List<ProvinceEntity>> getAll() {
    return collection.where().findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  Future<List<ProvinceEntity>> search(String keyword) {
    return isar.writeTxn(() async {
      return collection.where().filter().nameContains(keyword).findAll().then((collections) {
        return collections.map(getItemFromCollection).toList();
      });
    });
  }

  @override
  ProvinceModel updateNewItem(ProvinceEntity item) {
    return createNewItem(item)..id = item.id;
  }

  @override
  Future<void> clearAll() {
    return isar.writeTxn(() async {
      await collection.clear();
    });
  }
}

@Injectable(as: DistrictRepository)
class DistrictRepositoryImpl extends DistrictRepository with IsarCrudRepository<DistrictEntity, DistrictModel> {
  final Isar _isar = Isar.getInstance()!;

  @override
  IsarCollection<DistrictModel> get collection => isar.districtModels;

  @override
  DistrictModel createNewItem(DistrictEntity item) {
    return DistrictModel()
      ..provinceId = item.provinceId
      ..name = item.name;
  }

  @override
  Future<List<DistrictEntity>> getAll() {
    return collection.where().findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  DistrictEntity getItemFromCollection(DistrictModel collection) {
    return DistrictEntity(
      id: collection.id,
      provinceId: collection.provinceId ?? -1,
      name: collection.name ?? '',
    );
  }

  @override
  Isar get isar => _isar;

  @override
  Future<List<DistrictEntity>> search(String keyword) {
    return isar.writeTxn(() async {
      return collection.where().filter().nameContains(keyword).findAll().then((collections) {
        return collections.map(getItemFromCollection).toList();
      });
    });
  }

  @override
  DistrictModel updateNewItem(DistrictEntity item) {
    return createNewItem(item)..id = item.id;
  }

  @override
  Future<List<DistrictEntity>> searchByProvince(ProvinceEntity province, String keyword) {
    return isar.writeTxn(() async {
      return collection
          .where()
          .filter()
          .provinceIdEqualTo(province.id)
          .nameContains(keyword)
          .findAll()
          .then((collections) {
        return collections.map(getItemFromCollection).toList();
      });
    });
  }

  @override
  Future<void> clearAll() {
    return isar.writeTxn(() async {
      await collection.clear();
    });
  }
}

@Injectable(as: WardRepository)
class WardRepositoryImpl extends WardRepository with IsarCrudRepository<WardEntity, WardModel> {
  final Isar _isar = Isar.getInstance()!;

  @override
  IsarCollection<WardModel> get collection => isar.wardModels;

  @override
  WardModel createNewItem(WardEntity item) {
    return WardModel()
      ..districtId = item.districtId
      ..name = item.name;
  }

  @override
  Future<List<WardEntity>> getAll() {
    return collection.where().findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  WardEntity getItemFromCollection(WardModel collection) {
    return WardEntity(
      id: collection.id,
      districtId: collection.districtId ?? -1,
      name: collection.name ?? '',
    );
  }

  @override
  Isar get isar => _isar;

  @override
  Future<List<WardEntity>> search(String keyword) {
    return isar.writeTxn(() async {
      return collection.where().filter().nameContains(keyword).findAll().then((collections) {
        return collections.map(getItemFromCollection).toList();
      });
    });
  }

  @override
  WardModel updateNewItem(WardEntity item) {
    return createNewItem(item)..id = item.id;
  }

  @override
  Future<List<WardEntity>> searchByDistrict(DistrictEntity district, String keyword) {
    return isar.writeTxn(() async {
      return collection
          .where()
          .filter()
          .districtIdEqualTo(district.id)
          .nameContains(keyword)
          .findAll()
          .then((collections) {
        return collections.map(getItemFromCollection).toList();
      });
    });
  }

  @override
  Future<void> clearAll() {
    return isar.writeTxn(() async {
      await collection.clear();
    });
  }
}

@Injectable(as: FlatProvinceRepository)
class FlatProvinceRepositoryImpl extends FlatProvinceRepository
    with IsarCrudRepository<FlatProvinceEntity, FlatProvinceModel> {
  final Isar _isar = Isar.getInstance()!;

  @override
  IsarCollection<FlatProvinceModel> get collection => isar.flatProvinceModels;

  @override
  FlatProvinceModel createNewItem(FlatProvinceEntity item) {
    return FlatProvinceModel()
      ..combineId = item.combineId
      ..fullName = item.fullName;
  }

  @override
  Future<List<FlatProvinceEntity>> getAll() {
    return collection.where().findAll().then((collections) {
      return collections.map(getItemFromCollection).toList();
    });
  }

  @override
  FlatProvinceEntity getItemFromCollection(FlatProvinceModel collection) {
    return FlatProvinceEntity(
      id: collection.id,
      combineId: collection.combineId ?? '',
      fullName: collection.fullName ?? '',
    );
  }

  @override
  Isar get isar => _isar;

  @override
  Future<List<FlatProvinceEntity>> search(String keyword) {
    return isar.writeTxn(() async {
      return collection.where().filter().fullNameContains(keyword).findAll().then((collections) {
        return collections.map(getItemFromCollection).toList();
      });
    });
  }

  @override
  FlatProvinceModel updateNewItem(FlatProvinceEntity item) {
    return createNewItem(item)..id = item.id;
  }
}
