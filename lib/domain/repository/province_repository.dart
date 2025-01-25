import '../entity/index.dart';
import 'index.dart';

abstract class ClearAll {
  Future<void> clearAll();
}

abstract class ProvinceRepository
    implements
        CrudRepository<ProvinceEntity, int>,
        GetListRepository<ProvinceEntity>,
        SearchRepository<ProvinceEntity>,
        ClearAll {}

abstract class DistrictRepository
    implements
        CrudRepository<DistrictEntity, int>,
        GetListRepository<DistrictEntity>,
        SearchRepository<DistrictEntity>,
        ClearAll {
  Future<List<DistrictEntity>> searchByProvince(ProvinceEntity province, String keyword);
}

abstract class WardRepository
    implements CrudRepository<WardEntity, int>, GetListRepository<WardEntity>, SearchRepository<WardEntity>, ClearAll {
  Future<List<WardEntity>> searchByDistrict(DistrictEntity district, String keyword);
}

abstract class FlatProvinceRepository
    implements
        CrudRepository<FlatProvinceEntity, int>,
        GetListRepository<FlatProvinceEntity>,
        SearchRepository<FlatProvinceEntity> {}
