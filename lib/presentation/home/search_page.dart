import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:line_icons/line_icon.dart';

import '../../core/utils/search_utils.dart';
import '../../domain/entity/index.dart';
import '../../resource/index.dart';
import '../../route/app_router.dart';
import '../../widget/index.dart';
import '../land_certificate/cubit/search_group_cubit.dart';
import '../land_certificate/widget/land_certificate_card.dart';
import '../land_certificate/widget/land_certificate_filter_form.dart';
import '../utils/base_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BaseState<SearchPage, SearchGroupCubit, SearchGroupState> {
  //create debounce time for search
  final Debouncer _debouncer = Debouncer(milliseconds: 400);
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      cubit.search(value);
    });
  }

  @override
  void initState() {
    super.initState();
    cubit.search('');
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _debouncer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.hideKeyboard();
      },
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        const SafeArea(child: SizedBox.shrink()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm thành phố, tên,...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    fillColor: theme.canvasColor,
                    suffixIcon: AnimatedBuilder(
                      animation: _searchController,
                      builder: (context, child) {
                        if (_searchController.text.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return child!;
                      },
                      child: IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  LandCertificateFilterForm(
                    filter: cubit.state.filter,
                    onApply: (filter) {
                      cubit.setFilter(filter);
                    },
                  ).show(context, showDragHandle: false);
                },
                icon: BlocSelector<SearchGroupCubit, SearchGroupState, bool>(
                    selector: (state) => state.filter != null,
                    builder: (context, isHaveFilter) {
                      return Badge(
                        isLabelVisible: isHaveFilter,
                        child: LineIcon(
                          LineIcons.filter,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        const Gap(20),
        Expanded(child: BlocBuilder<SearchGroupCubit, SearchGroupState>(
          builder: (BuildContext context, state) {
            if (state.list.isEmpty) {
              return EmptyLandCertificateWidget();
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final provinceCountEntity = state.list[index];
                return CountSearchCard(
                  query: state.query,
                  filter: state.filter,
                  countSearch: provinceCountEntity,
                );
              },
              separatorBuilder: (context, index) => const Gap(8),
            );
          },
        )),
      ],
    );
  }
}

class CountSearchCard extends StatelessWidget {
  const CountSearchCard({
    super.key,
    required this.countSearch,
    this.query,
    required this.filter,
  });

  final ProvinceCountEntity countSearch;
  final String? query;
  final FilterLandCertificateEntity? filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ExpansionTile(
        key: ValueKey(countSearch.id),
        shape: const RoundedRectangleBorder(),
        // backgroundColor: theme.cardTheme.color,
        childrenPadding: const EdgeInsets.all(16),
        title: ListTile(
          // title: Text('${countSearch.name}'),

          title: TextHighlight(
            text: countSearch.name,
            softWrap: false,
            textStyle: theme.textTheme.titleMedium,
            words: query == null
                ? {}
                : {
                    query!: HighlightedWord(
                      textStyle: theme.textTheme.titleMedium,
                      decoration: BoxDecoration(
                        color: theme.primaryColorLight,
                      ),
                    ),
                  },
          ),
          trailing:
              Text('${countSearch.total} ${countSearch.total == 1 ? LKey.certificate.tr() : LKey.certificates.tr()}'),
        ),
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final district = countSearch.districts[index];
              return ListTile(
                tileColor: theme.cerCardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                title: Text('${district.name}'),
                trailing: Text(
                    '${district.total} ${countSearch.total == 1 ? LKey.certificate.tr() : LKey.certificates.tr()}'),
                onTap: () {
                  final districtEntity = DistrictEntity(
                    id: district.id,
                    provinceId: countSearch.id,
                    name: district.name,
                  );

                  appRouter.goToCertificateGroupByDistrict(
                    districtEntity,
                    SearchInformationEntity(
                      keyword: query ?? '',
                      filter: filter,
                    ),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
            itemCount: countSearch.districts.length,
          )
        ],
      ),
    );
  }
}
