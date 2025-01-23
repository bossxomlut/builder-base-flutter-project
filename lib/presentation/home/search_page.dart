import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/index.dart';
import '../../route/app_router.dart';
import '../../widget/index.dart';
import '../land_certificate/cubit/search_group_cubit.dart';
import '../utils/base_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BaseState<SearchPage, SearchGroupCubit, SearchGroupState> {
  @override
  void initState() {
    super.initState();
    cubit.search('');
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        const SafeArea(child: SizedBox.shrink()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (value) {
              cubit.search(value);
            },
            decoration: InputDecoration(
              hintText: 'Search by province',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              fillColor: theme.canvasColor,
            ),
          ),
        ),
        const Gap(20),
        Expanded(child: BlocBuilder<SearchGroupCubit, SearchGroupState>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final provinceCountEntity = state.list[index];
                return CountSearchCard(
                  countSearch: provinceCountEntity,
                );
              },
            );
          },
        )),
      ],
    );
  }
}

class CountSearchCard extends StatelessWidget {
  const CountSearchCard({super.key, required this.countSearch});
  final ProvinceCountEntity countSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(),
        backgroundColor: theme.cardTheme.color,
        childrenPadding: const EdgeInsets.all(16),
        title: ListTile(
          title: Text('${countSearch.name}'),
          trailing: Text('${countSearch.total} certificates'),
        ),
        children: [
          for (var district in countSearch.districts)
            ListTile(
              tileColor: theme.colorScheme.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              title: Text('${district.name}'),
              trailing: Text('${district.total} certificates'),
              onTap: () {
                final districtEntity = DistrictEntity(
                  id: district.id,
                  provinceId: countSearch.id,
                  name: district.name,
                );

                print('districtEntity: $districtEntity');

                appRouter.goToCertificateGroupByDistrict(
                  districtEntity,
                );
              },
            ),
        ],
      ),
    );
  }
}
