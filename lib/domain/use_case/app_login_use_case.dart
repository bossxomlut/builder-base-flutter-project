import 'package:injectable/injectable.dart';

import '../../core/index.dart';
import '../../injection/injection.dart';
import '../../route/app_router.dart';
import '../../route/app_router.gr.dart';
import '../index.dart';

@injectable
class AppLogoutUseCase extends FutureUseCase<void, void> {
  AppLogoutUseCase(this._googleLogoutUseCase);

  final GoogleLogoutUseCase _googleLogoutUseCase;

  @override
  Future<void> execute(void input) async {
    await _googleLogoutUseCase.execute(null);
    //todo: clear database
    appRouter.goToGoogleLoginAtTop();
  }
}

@injectable
class AppLoginUseCase extends FutureUseCase<void, void> {
  AppLoginUseCase(this.checkGoogleLoginUseCase);

  final CheckGoogleLoginUseCase checkGoogleLoginUseCase;

  @override
  Future<void> execute(void input) async {
    if (await checkGoogleLoginUseCase.execute(null)) {
      getIt.get<CheckLoginByPinCodeUseCase>().execute(null);
    } else {
      appRouter.goToGoogleLoginAtTop();
    }
  }
}

@injectable
class CheckLoginByPinCodeUseCase extends FutureUseCase<void, void> {
  CheckLoginByPinCodeUseCase();

  @override
  Future<void> execute(void input) {
    return getIt.get<CheckConfiguredPinCodeUseCase>().execute(null).then(
      (bool value) {
        if (value) {
          appRouter.goToPinCodeAtTop();
        } else {
          appRouter.replaceAll([const SetUpPinCodeRoute()]);
        }
      },
    );
  }
}
