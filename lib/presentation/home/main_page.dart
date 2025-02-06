import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sample_app/presentation/home/search_page.dart';
import 'package:sample_app/presentation/home/settings_page.dart';

import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../resource/index.dart';
import '../../route/app_router.dart';
import '../../widget/index.dart';
import '../utils/index.dart';
import 'home_page.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _InitMain();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          HomePage(),
          // SearchProvincePage(),
          SearchPage(),
          SettingsPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(LineIcons.plus),
        onPressed: () {
          appRouter.goToAddLandCertificate();
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: AnimatedBuilder(
              animation: _tabController,
              builder: (BuildContext context, Widget? child) {
                return GNav(
                  gap: 8,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 300),
                  tabActiveBorder: Border.all(
                    color: theme.colorScheme.secondary,
                    width: 2,
                  ), // tab button border
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: LKey.home.tr(),
                    ),
                    GButton(
                      icon: LineIcons.search,
                      text: LKey.search.tr(),
                    ),
                    GButton(
                      icon: LineIcons.cog,
                      text: LKey.settings.tr(),
                    ),
                  ],
                  selectedIndex: _tabController.index,
                  onTabChange: (index) {
                    _tabController.animateTo(index);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _InitMain extends _MainPageState with LoadingState {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoading();

      await Future.wait([
        getIt.get<CheckInitialDataUseCase>().execute(null),
        getIt.get<CheckInitialProvinceDataUseCase>().execute(null),
      ]);

      hideLoading();

      getIt.get<ScheduleUploadDataUseCase>().execute(null);
    });
  }

  @override
  void dispose() {
    getIt.get<ScheduleUploadDataUseCase>().cancel();

    super.dispose();
  }

  @override
  Widget buildLoading(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.dialogTheme.barrierColor ?? Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: ColoredBox(
                    color: theme.colorScheme.onPrimaryContainer,
                    child: Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: theme.colorScheme.primary,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: ColoredBox(
                    color: theme.colorScheme.onSecondary,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LText(
                            LKey.processing,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Gap(2),
                          LText(
                            LKey.messageProcessingDescription,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
