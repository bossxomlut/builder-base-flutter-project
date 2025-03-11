import 'package:injectable/injectable.dart';

import '../../core/index.dart';
import '../index.dart';

@injectable
class CreateLandCertificateUseCase {
  final LandCertificateRepository _landCertificateRepository;

  CreateLandCertificateUseCase(this._landCertificateRepository);

  Future<void> execute(LandCertificateEntity landCertificate) async {
    final otherAreas = landCertificate.otherAreas?.toList() ?? [];

    //clear other areas that have no residential area or perennial tree area
    otherAreas.removeWhere((a) => a.area == null);

    final lastedCertificate = landCertificate.copyWith(otherAreas: otherAreas);

    if (landCertificate.id != -1) {
      await _landCertificateRepository.update(lastedCertificate);
    } else {
      await _landCertificateRepository.create(lastedCertificate);
    }
  }
}

//delete usecase
@injectable
class DeleteLandCertificateUseCase extends UseCase<void, LandCertificateEntity> {
  final LandCertificateRepository _landCertificateRepository;

  DeleteLandCertificateUseCase(this._landCertificateRepository);

  @override
  void execute(LandCertificateEntity input) {
    _landCertificateRepository.delete(input);
  }
}
