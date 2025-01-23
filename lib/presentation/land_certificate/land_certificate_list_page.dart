import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_icons/line_icons.dart';

import '../../domain/index.dart';
import '../../resource/index.dart';
import '../../widget/index.dart';
import '../utils/base_state.dart';
import 'cubit/land_certificate_list_cubit.dart';
import 'widget/land_certificate_card.dart';

@RoutePage()
class LandCertificateListPage extends StatefulWidget {
  const LandCertificateListPage({
    super.key,
    required this.level,
    this.province,
    this.district,
    this.ward,
  });

  final ProvinceLevel level;
  final ProvinceEntity? province;
  final DistrictEntity? district;
  final WardEntity? ward;

  factory LandCertificateListPage.province(ProvinceEntity province) {
    return LandCertificateListPage(level: ProvinceLevel.province, province: province);
  }

  factory LandCertificateListPage.district(DistrictEntity district) {
    return LandCertificateListPage(level: ProvinceLevel.district, district: district);
  }

  factory LandCertificateListPage.ward(WardEntity ward) {
    return LandCertificateListPage(level: ProvinceLevel.ward, ward: ward);
  }

  @override
  State<LandCertificateListPage> createState() => _LandCertificateListPageState();
}

class _LandCertificateListPageState
    extends BaseState<LandCertificateListPage, LandCertificateListCubit, LandCertificateListState> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<LandCertificateEntity> _items = [];
  final ValueNotifier<bool> isEmptyNotifier = ValueNotifier(true);

  final Duration _duration = Duration(milliseconds: 300);

  void _removeItem(int index) {
    final removedItem = _items[index];

    cubit.remove(removedItem);

    _items.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, index, animation),
      duration: _duration,
    );

    if (_items.isEmpty) {
      Future.delayed(_duration, () {
        try {
          isEmptyNotifier.value = true;
        } catch (e) {}
      });
    }
  }

  void _addItem(LandCertificateEntity item) {
    _items.add(item);

    _listKey.currentState?.insertItem(
      _items.length - 1,
      duration: _duration,
    );
  }

  Widget _buildItem(LandCertificateEntity item, int index, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: Slidable(
        child: LandCertificateCard(
          item,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        enabled: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                _removeItem(index);
              },
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              icon: LineIcons.trash,
              label: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cubit
      ..setLevel(
        widget.level,
        province: widget.province,
        district: widget.district,
        ward: widget.ward,
      )
      ..search('');
  }

  @override
  void dispose() {
    isEmptyNotifier.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBar(title: title);
  }

  String get title {
    switch (widget.level) {
      case ProvinceLevel.province:
        return widget.province!.name;
      case ProvinceLevel.district:
        return widget.district!.name;
      case ProvinceLevel.ward:
        return widget.ward!.name;
      case ProvinceLevel.all:
        return LKey.all.tr();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocListener<LandCertificateListCubit, LandCertificateListState>(
      listener: (BuildContext context, state) {
        isEmptyNotifier.value = state.list.isEmpty;

        for (int i = 0; i < state.list.length; i++) {
          _addItem(state.list[i]);
        }
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: isEmptyNotifier,
          builder: (context, isEmpty, _) {
            if (isEmpty) {
              return EmptyLandCertificateWidget();
            }

            return AnimatedList.separated(
              key: _listKey,
              initialItemCount: _items.length,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemBuilder: (context, index, animation) {
                return _buildItem(_items[index], index, animation);
              },
              separatorBuilder: (context, index, _) {
                return const SizedBox(height: 16.0);
              },
              removedSeparatorBuilder: (context, index, animation) {
                return const SizedBox(height: 16.0);
              },
            );
          }),
    );
  }
}
