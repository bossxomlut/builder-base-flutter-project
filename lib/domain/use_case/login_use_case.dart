import 'package:injectable/injectable.dart';

import '../../core/index.dart';
import '../../core/utils/encrypt_utils.dart';
import '../../resource/index.dart';
import '../../route/app_router.dart';
import '../../widget/toast.dart';
import '../entity/index.dart';
import '../repository/index.dart';

@injectable
class CheckConfiguredPinCodeUseCase extends FutureUseCase<bool, void> {
  CheckConfiguredPinCodeUseCase(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;
  @override
  Future<bool> execute(void input) {
    return _pinCodeRepository.isSetPinCode;
  }
}

@injectable
class SavePinCodeUseCase extends UseCase<void, SavePinCodeParamEntity> {
  SavePinCodeUseCase(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  @override
  void execute(SavePinCodeParamEntity input) {
    _pinCodeRepository.savePinCode(
      input.question,
      input.answer,
      input.pin,
    );
  }
}

@injectable
class GetSecurityQuestionsUseCase extends UseCase<List<SecurityQuestionEntity>, void> {
  GetSecurityQuestionsUseCase(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  @override
  List<SecurityQuestionEntity> execute(void input) {
    return _pinCodeRepository.securityQuestions;
  }
}

@injectable
class CheckSecurityQuestionUseCase extends FutureUseCase<bool, CheckSecurityQuestionParamEntity> {
  CheckSecurityQuestionUseCase(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  @override
  Future<bool> execute(CheckSecurityQuestionParamEntity input) {
    return _pinCodeRepository.checkSecurityQuestion(
      input.question,
      input.answer,
    );
  }
}

@injectable
class LoginUseCase extends FutureUseCase<void, String> {
  LoginUseCase(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  @override
  Future<void> execute(String input) {
    return _pinCodeRepository.login(input);
  }
}

@injectable
class UpdatePinCodeUseCase extends FutureUseCase<void, UpdatePinCodeParamEntity> {
  UpdatePinCodeUseCase(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  @override
  Future<void> execute(UpdatePinCodeParamEntity input) {
    return _pinCodeRepository
        .updatePinCode(
      input.confirmPin,
      input.newPin,
    )
        .then((_) {
      showSuccess(message: LKey.messagePinCodeUpdatedSuccessfully.tr());
      appRouter.goHome();
    }).catchError((error) {
      showError(message: LKey.messageIncorrectPinCode.tr());
    });
  }
}

@injectable
class GetEncryptPinCodeUseCase extends FutureUseCase<String, void> {
  GetEncryptPinCodeUseCase(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  @override
  Future<String> execute(void input) async {
    final pinCode = await _pinCodeRepository.getPinCode();

    return PinCodeEncryptUtils.encryptToLettersWithExtra(pinCode);
  }
}
