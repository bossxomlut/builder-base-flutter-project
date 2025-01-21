import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

export 'route_logger_observer.dart';

final AppRouter _appRouter = AppRouter();

AppRouter get appRouter => _appRouter;

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: MainRoute.page),
        AutoRoute(page: PinCodeRoute.page),
        AutoRoute(page: SetUpPinCodeRoute.page),
        AutoRoute(page: ForgotPinCodeRoute.page),
        AutoRoute(page: UpdatePinCodeRoute.page),
      ];
}

extension AppRouterX on AppRouter {
  void goHome() {
    replaceAll(const [MainRoute()]);
  }

  void goToLogin() {
    push(const PinCodeRoute());
  }

  void goToLoginAtTop() {
    replaceAll(const [PinCodeRoute()]);
  }

  void pushAndRemoveUntilHome(PageRouteInfo route) {
    pushAndPopUntil(route, predicate: (r) => r.isFirst);
  }

  void pushAndReplaceAll(PageRouteInfo route) {
    pushAndPopUntil(route, predicate: (r) => false);
  }
}
