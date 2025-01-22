import '../entity/index.dart';
import 'index.dart';

abstract class ProvinceRepository
    implements
        CrudRepository<ProvinceEntity, int>,
        GetListRepository<ProvinceEntity>,
        SearchRepository<ProvinceEntity> {}

abstract class DistrictRepository
    implements
        CrudRepository<DistrictEntity, int>,
        GetListRepository<DistrictEntity>,
        SearchRepository<DistrictEntity> {
  Future<List<DistrictEntity>> searchByProvince(ProvinceEntity province, String keyword);
}

abstract class WardRepository
    implements CrudRepository<WardEntity, int>, GetListRepository<WardEntity>, SearchRepository<WardEntity> {
  Future<List<WardEntity>> searchByDistrict(DistrictEntity district, String keyword);
}

abstract class FlatProvinceRepository
    implements
        CrudRepository<FlatProvinceEntity, int>,
        GetListRepository<FlatProvinceEntity>,
        SearchRepository<FlatProvinceEntity> {}
