import 'package:injectable/injectable.dart';

import '../../core/index.dart';
import '../index.dart';

//[LC] is short of Land Certificate

@injectable
class SearchGroundCertificateUseCase extends FutureUseCase<List<ProvinceCountEntity>, SearchInformationEntity> {
  SearchGroundCertificateUseCase(this._repository);

  final SearchGroupCertificateRepository _repository;

  @override
  Future<List<ProvinceCountEntity>> execute(SearchInformationEntity input) {
    return _repository.searchAndFilter(input.keyword, input.filter);
  }
}

@injectable
class SearchLCByKeywordUseCase extends FutureUseCase<List<LandCertificateEntity>, SearchInformationEntity> {
  SearchLCByKeywordUseCase(this._landCertificateRepository);

  final LandCertificateRepository _landCertificateRepository;
  @override
  Future<List<LandCertificateEntity>> execute(SearchInformationEntity input) {
    return _landCertificateRepository.searchAndFilter(input.keyword, input.filter);
  }
}

@injectable
class SearchLCByProvinceUseCase extends FutureUseCase<List<LandCertificateEntity>, ProvinceSearchInformationEntity> {
  SearchLCByProvinceUseCase(this._landCertificateRepository);

  final LandCertificateRepository _landCertificateRepository;
  @override
  Future<List<LandCertificateEntity>> execute(ProvinceSearchInformationEntity input) {
    final LandCertificateSearchBuilder builder = LandCertificateSearchBuilder();

    builder.keyword(input.keyword);

    if (input.filter != null) {
      builder.filter(input.filter!);
    }

    if (input.province != null) {
      builder.province(input.province!.id);
    }

    if (input.district != null) {
      builder.province(input.district!.provinceId).district(input.district!.id);
    }

    if (input.ward != null) {
      builder.district(input.ward!.districtId).ward(input.ward!.id);
    }

    return _landCertificateRepository.searchByBuilder(builder);
  }
}
