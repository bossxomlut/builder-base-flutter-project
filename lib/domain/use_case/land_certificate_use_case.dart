import 'package:injectable/injectable.dart';

import '../index.dart';

@injectable
class CreateLandCertificateUseCase {
  final LandCertificateRepository _landCertificateRepository;

  CreateLandCertificateUseCase(this._landCertificateRepository);

  Future<void> execute(LandCertificateEntity landCertificate) async {
    await _landCertificateRepository.create(landCertificate);
  }
}
