import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/index.dart';
import '../../resource/index.dart';
import '../../widget/index.dart';
import '../province/search_province_page.dart';
import '../utils/index.dart';
import 'cubit/config_setting_cubit.dart';

@RoutePage()
class ConfigSettingPage extends StatefulWidget {
  const ConfigSettingPage({Key? key}) : super(key: key);

  @override
  State<ConfigSettingPage> createState() => _ConfigSettingPageState();
}

class _ConfigSettingPageState extends BaseState<ConfigSettingPage, ConfigSettingCubit, ConfigSettingState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const CustomAppBar(
      title: 'Cấu hình mặc định',
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<ConfigSettingCubit, ConfigSettingState>(
      bloc: cubit,
      builder: (BuildContext context, ConfigSettingState state) {
        return ListView(
          children: [
            ListTile(
              title: const Text('Thành phố'),
              subtitle: state.defaultProvince != null ? Text(state.defaultProvince?.name ?? '---') : null,
              leading: Icon(
                LineIcons.city,
                color: theme.iconTheme.color,
              ),
              onTap: () {
                SearchProvincePage.searchProvince().show(context).then(
                  (ProvinceSearchEntity? value) {
                    if (value != null) {
                      cubit.updateDefaultProvince(value.province.name);
                    }
                  },
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppDivider(),
            ),
            ExpansionTile(
              shape: const RoundedRectangleBorder(),
              tilePadding: const EdgeInsets.only(right: 20),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: ListTile(
                title: const Text('Màu sắc đánh dấu'),
                leading: Icon(
                  LineIcons.palette,
                  color: theme.iconTheme.color,
                ),
              ),
              children: [
                ListTile(
                  leading: Container(
                    width: 20,
                    height: 20,
                    color: theme.getWarningByCountDate(0),
                  ),
                  title: const Text('Trễ hạn'),
                ),
                const AppDivider(),
                ListTile(
                  leading: Container(
                    width: 20,
                    height: 20,
                    color: theme.getWarningByCountDate(1),
                  ),
                  title: const Text('Còn 3 ngày'),
                ),
                const AppDivider(),
                ListTile(
                  leading: Container(
                    width: 20,
                    height: 20,
                    color: theme.getWarningByCountDate(10),
                  ),
                  title: const Text('Còn 10 ngày'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
