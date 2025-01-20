import 'package:flutter/material.dart';

import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../route/app_router.dart';
import '../../route/app_router.gr.dart';
import '../utils/index.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with StateTemplate<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationHandler();
    });
  }

  void navigationHandler() {
    getIt.get<CheckConfiguredPinCodeUseCase>().execute(null).then(
      (bool value) {
        if (value) {
          appRouter.goToLoginAtTop();
        } else {
          appRouter.replaceAll([const SetUpPinCodeRoute()]);
        }
      },
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text('Splash Screen\nHello World!'),
    );
  }
}
