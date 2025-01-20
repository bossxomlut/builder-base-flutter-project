import '../entity/index.dart';

abstract class PinCodeRepository {
  Future<bool> get isSetPinCode;

  Future<String> getPinCode();

  void savePinCode(SecurityQuestionEntity securityQuestionEntity, String answer, String pin);

  Future<void> updatePinCode(String confirmPin, String newPin);

  Future<bool> checkSecurityQuestion(SecurityQuestionEntity question, String answer);

  List<SecurityQuestionEntity> get securityQuestions;

  Future<void> login(String pin);
}
