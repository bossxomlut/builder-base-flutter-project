import 'package:auto_route/auto_route.dart';

import '../domain/index.dart';
import '../presentation/land_certificate/cubit/land_certificate_list_cubit.dart';
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
        AutoRoute(page: AddLandCertificateRoute.page),
        AutoRoute(page: LandCertificateListRoute.page),
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

extension LandCertificateListRouteX on AppRouter {
  void goToCertificateGroupByProvince(ProvinceEntity province) {
    push(LandCertificateListRoute(level: ProvinceLevel.province, province: province));
  }

  void goToCertificateGroupByDistrict(DistrictEntity district) {
    push(LandCertificateListRoute(level: ProvinceLevel.district, district: district));
  }

  void goToCertificateGroupByWard(WardEntity ward) {
    push(LandCertificateListRoute(level: ProvinceLevel.ward, ward: ward));
  }

  void goToCertificateGroupByAll() {
    push(LandCertificateListRoute(level: ProvinceLevel.all));
  }
}

extension LandCertificateRouteX on AppRouter {
  void goToAddLandCertificate() {
    push(AddLandCertificateRoute());
  }

  void goToViewLandCertificate(LandCertificateEntity landCertificate) {
    push(AddLandCertificateRoute(initialLandCertificateEntity: landCertificate));
  }
}
