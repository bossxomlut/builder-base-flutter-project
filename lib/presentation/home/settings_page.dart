import 'package:flutter/material.dart';

import '../../domain/index.dart';
import '../../domain/use_case/app_login_use_case.dart';
import '../../domain/use_case/sync_data_use_case.dart';
import '../../injection/injection.dart';
import '../../resource/index.dart';
import '../../route/app_router.dart';
import '../../route/app_router.gr.dart';
import '../../widget/index.dart';
import '../utils/index.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with StateTemplate<SettingsPage> {
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SafeArea(child: SizedBox.shrink()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LText(
            LKey.settings,
            style: theme.textTheme.displaySmall,
          ),
        ),
        const Gap(20),
        // ExpansionTile(
        //   shape: const RoundedRectangleBorder(),
        //   tilePadding: EdgeInsets.only(right: 20),
        //   childrenPadding: EdgeInsets.symmetric(horizontal: 20),
        //   title: ListTile(
        //     title: const LText(LKey.language),
        //     leading: const Icon(LineIcons.language),
        //   ),
        //   children: [
        //     ListTile(
        //       title: const LText(LKey.english),
        //       onTap: () {
        //         context.setLocale(const Locale('en', 'US'));
        //       },
        //       trailing: context.locale == Locale('en', 'US') ? const Icon(LineIcons.check) : null,
        //     ),
        //     ListTile(
        //       title: const LText(LKey.vietnamese),
        //       onTap: () {
        //         context.setLocale(const Locale('vi', 'VN'));
        //       },
        //       trailing: context.locale == Locale('vi', 'VN') ? const Icon(LineIcons.check) : null,
        //     ),
        //   ],
        // ),
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20),
        //   child: AppDivider(),
        // ),
        ListTile(
          title: const Text('Đồng bộ dữ liệu'),
          leading: const Icon(LineIcons.syncIcon),
          onTap: () {
            ProcessingWidget(
              execute: () => Future.sync(() async {
                await Future.delayed(const Duration(seconds: 1));
                // await getIt.get<UploadDataUseCase>().execute(null);
                await getIt.get<SyncDataUseCase>().execute(null);
              }),
              onCompleted: () {
                // Navigator.of(context).pop();
              },
              messageSuccessDescription: 'Đồng bộ dữ liệu thành công',
            ).show(context);
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: AppDivider(),
        ),
        ListTile(
          title: const LText(LKey.darkMode),
          leading: const Icon(LineIcons.moonAlt),
          trailing: ValueListenableBuilder(
              valueListenable: ThemeUtils.themeModeNotifier,
              builder: (context, themMode, _) {
                return Switch(
                  value: themMode == ThemeMode.dark,
                  onChanged: (bool value) {
                    ThemeUtils.toggleThemeMode();
                  },
                );
              }),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: AppDivider(),
        ),
        ListTile(
          title: const LText(LKey.updatePinCode),
          leading: const Icon(LineIcons.key),
          trailing: const Icon(LineIcons.arrowRight),
          onTap: () {
            appRouter.push(const UpdatePinCodeRoute());
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: AppDivider(),
        ),
        ListTile(
          title: const LText(LKey.logout),
          leading: const Icon(LineIcons.alternateSignOut),
          onTap: () {
            getIt.get<AppLogoutUseCase>().execute(null);
          },
        ),
      ],
    );
  }
}
