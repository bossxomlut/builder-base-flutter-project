import '../../data/model/observer_data.dart';
import '../index.dart';

abstract class LandCertificateRepository
    implements
        CrudRepository<LandCertificateEntity, int>,
        GetListRepository<LandCertificateEntity>,
        SearchRepository<LandCertificateEntity> {
  Future<List<LandCertificateEntity>> searchByProvince(ProvinceEntity province, String keyword);
  Future<List<LandCertificateEntity>> searchByDistrict(DistrictEntity district, String keyword);
  Future<List<LandCertificateEntity>> searchByWard(WardEntity ward, String keyword);
  Future<LandCertificateEntity> readByCerId(String cerId);
  Future<int> findIndexByCerId(String cerId);
  Future<List<LandCertificateEntity>> searchAndFilter(String keyword, FilterLandCertificateEntity? filter);
  Future<List<LandCertificateEntity>> searchByBuilder(LandCertificateSearchBuilder builder);
}

//listen have any change in database
abstract class LandCertificateObserverData extends SingleStreamObserverData<void> {}

abstract class ProvinceLandCertificateRepository
    implements GetListRepository<ProvinceLandCertificateEntity>, SearchRepository<ProvinceLandCertificateEntity> {}

abstract class SearchGroupCertificateRepository
    implements GetListRepository<ProvinceCountEntity>, SearchRepository<ProvinceCountEntity> {
  Future<List<ProvinceCountEntity>> searchAndFilter(String keyword, FilterLandCertificateEntity? filter);
}
