import 'package:injectable/injectable.dart';

import '../index.dart';

@injectable
class CreateLandCertificateUseCase {
  final LandCertificateRepository _landCertificateRepository;

  CreateLandCertificateUseCase(this._landCertificateRepository);

  Future<void> execute(LandCertificateEntity landCertificate) async {
    final otherAreas = landCertificate.otherAreas ?? [];

    //clear other areas that have no residential area or perennial tree area
    otherAreas.removeWhere((a) => a.residentialArea == null && a.perennialTreeArea == null);

    final lastedCertificate = landCertificate.copyWith(otherAreas: otherAreas);

    if (landCertificate.id != -1) {
      await _landCertificateRepository.update(lastedCertificate);
    } else {
      await _landCertificateRepository.create(lastedCertificate);
    }
  }
}
