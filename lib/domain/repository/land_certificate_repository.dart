import '../index.dart';

abstract class LandCertificateRepository
    implements
        CrudRepository<LandCertificateEntity, int>,
        GetListRepository<LandCertificateEntity>,
        SearchRepository<LandCertificateEntity> {}
