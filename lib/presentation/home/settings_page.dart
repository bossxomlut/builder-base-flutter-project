import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

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
        ExpansionTile(
          shape: const RoundedRectangleBorder(),
          tilePadding: EdgeInsets.only(right: 20),
          childrenPadding: EdgeInsets.symmetric(horizontal: 20),
          title: ListTile(
            title: const LText(LKey.language),
            leading: const Icon(LineIcons.language),
          ),
          children: [
            ListTile(
              title: const LText(LKey.english),
              onTap: () {
                context.setLocale(const Locale('en', 'US'));
              },
              trailing: context.locale == Locale('en', 'US') ? const Icon(LineIcons.check) : null,
            ),
            ListTile(
              title: const LText(LKey.vietnamese),
              onTap: () {
                context.setLocale(const Locale('vi', 'VN'));
              },
              trailing: context.locale == Locale('vi', 'VN') ? const Icon(LineIcons.check) : null,
            ),
          ],
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
            appRouter.goToLoginAtTop();
          },
        ),
      ],
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
    );
  }
}
