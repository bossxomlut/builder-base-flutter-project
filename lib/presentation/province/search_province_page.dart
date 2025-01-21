import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../domain/entity/index.dart';
import '../../widget/index.dart';
import '../home/settings_page.dart';
import '../utils/index.dart';
import 'cubit/seach_province_cubit.dart';

class SearchProvincePage extends StatefulWidget {
  const SearchProvincePage({super.key});

  @override
  State<SearchProvincePage> createState() => _SearchProvincePageState();
}

class _SearchProvincePageState extends BaseState<SearchProvincePage, SearchProvinceCubit, SearchProvinceState> {
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Search Province', style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  onChanged: (String value) {
                    cubit.onSearch(value);
                  },
                  hintText: 'Search Province',
                  leading: Icon(LineIcons.search),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(LineIcons.filter),
                onPressed: () {
                  ProvinceFilterWidget().show(context).then(
                    (dynamic value) {
                      if (value != null) {
                        cubit.onFilterChanged(value as SearchFilterType);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchProvinceCubit, SearchProvinceState>(builder: (context, state) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.results.length,
              itemBuilder: (BuildContext context, int index) {
                final item = state.results[index];
                return ListTile(
                  title: Text(item.name),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class ProvinceFilterWidget extends StatelessWidget with ShowBottomSheet {
  const ProvinceFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 40),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(SearchFilterType.values[index].name),
          onTap: () {
            Navigator.pop(context, SearchFilterType.values[index]);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return AppDivider();
      },
      itemCount: SearchFilterType.values.length,
    );
  }
}
