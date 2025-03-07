import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/index.dart';
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
    return CustomAppBar(
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
              leading: const Icon(LineIcons.city),
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
          ],
        );
      },
    );
  }
}
