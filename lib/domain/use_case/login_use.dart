import '../../core/index.dart';

class LoginByPinCodeUseCase extends FutureUseCase<void, String> {
  @override
  Future<void> execute(String input) {
    if (input == '0000') {
      return Future.value();
    } else {
      return Future.error('Invalid pin code');
    }
  }
}
