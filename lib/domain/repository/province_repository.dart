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
        SearchRepository<DistrictEntity> {}

abstract class WardRepository
    implements CrudRepository<WardEntity, int>, GetListRepository<WardEntity>, SearchRepository<WardEntity> {}
