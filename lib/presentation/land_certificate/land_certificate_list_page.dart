import 'package:animation_list/animation_list.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../domain/index.dart';
import '../../resource/index.dart';
import '../../widget/index.dart';
import '../../widget/toast.dart';
import '../utils/base_state.dart';
import 'cubit/land_certificate_list_cubit.dart';
import 'widget/land_certificate_card.dart';

@RoutePage()
class LandCertificateListPage extends StatefulWidget {
  const LandCertificateListPage({
    super.key,
    this.province,
    this.district,
    this.ward,
    required this.searchInformation,
  });

  final ProvinceEntity? province;
  final DistrictEntity? district;
  final WardEntity? ward;
  final SearchInformationEntity? searchInformation;

  @override
  State<LandCertificateListPage> createState() => _LandCertificateListPageState();
}

class _LandCertificateListPageState
    extends BaseState<LandCertificateListPage, LandCertificateListCubit, LandCertificateListState> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<LandCertificateEntity> _items = [];
  final ValueNotifier<bool> isEmptyNotifier = ValueNotifier(true);

  final Duration _duration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    cubit
      ..init(
        keyword: widget.searchInformation?.keyword ?? '',
        filter: widget.searchInformation?.filter,
        province: widget.province,
        district: widget.district,
        ward: widget.ward,
      )
      ..onSearch(null)
      ..startListen();
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
    return widget.province?.name ?? widget.district?.name ?? widget.ward?.name ?? LKey.all.tr();
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<LandCertificateListCubit, LandCertificateListState>(
      builder: (BuildContext context, LandCertificateListState state) {
        if (state.list.isEmpty) {
          return EmptyLandCertificateWidget();
        }

        return AnimationList(
            animationDirection: AnimationDirection.horizontal,
            duration: 1000,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            children: List.generate(
              state.list.length,
              (index) {
                final item = state.list[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Slidable(
                    child: LandCertificateCard(
                      item,
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          autoClose: false,
                          onPressed: (BuildContext context) {
                            AppDialog(
                              title: LKey.delete.tr(),
                              description: LKey.messageDeleteItemConfirmDescription.tr(),
                              onConfirm: () {
                                cubit.remove(item);
                                showSuccess(message: 'Bạn đã xoá thành công');
                              },
                              onCancel: () {},
                            ).show(context);
                          },
                          backgroundColor: Theme.of(context).colorScheme.errorContainer,
                          icon: LineIcons.trash,
                          label: LKey.delete.tr(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
      },
    );

    return BlocListener<LandCertificateListCubit, LandCertificateListState>(
      listener: (BuildContext context, state) {
        final prvL = _items.length;

        if (state.list.length > prvL) {
          final diff = state.list.toSet().difference(_items.toSet()).toList();

          _items.addAll(diff);

          isEmptyNotifier.value = _items.isEmpty;

          _listKey.currentState?.insertAllItems(
            prvL,
            _items.length,
            duration: _duration,
          );
        } else {
          final diff = _items.toSet().difference(state.list.toSet()).toList();

          print('diff: $diff');

          // for (var item in diff) {
          //   final index = _items.indexWhere((element) => element == item);
          //   _items.removeAt(index);
          //
          //   _listKey.currentState?.removeItem(
          //     index,
          //     (context, animation) => _buildItem(item, index, animation),
          //     duration: _duration,
          //   );
          // }

          if (_items.isEmpty) {
            Future.delayed(_duration, () {
              try {
                isEmptyNotifier.value = true;
              } catch (e) {}
            });
          }
        }
      },
      listenWhen: (previous, current) {
        return previous.list != current.list;
      },
      child: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: isEmptyNotifier,
            builder: (context, isEmpty, _) {
              if (isEmpty) {
                return EmptyLandCertificateWidget();
              }
              return const SizedBox();
            },
          ),
          Expanded(
            child: AnimatedList.separated(
              key: _listKey,
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
            ),
          ),
        ],
      ),
    );
    // return BlocListener<LandCertificateListCubit, LandCertificateListState>(
    //   listener: (BuildContext context, state) {
    //     final prvL = _items.length;
    //
    //     if (state.list.length > prvL) {
    //       final diff = state.list.toSet().difference(_items.toSet()).toList();
    //
    //       _items.addAll(diff);
    //
    //       isEmptyNotifier.value = _items.isEmpty;
    //
    //       _listKey.currentState?.insertAllItems(
    //         prvL,
    //         _items.length,
    //         duration: _duration,
    //       );
    //     } else {
    //       final diff = _items.toSet().difference(state.list.toSet()).toList();
    //
    //       print('diff: $diff');
    //
    //       // for (var item in diff) {
    //       //   final index = _items.indexWhere((element) => element == item);
    //       //   _items.removeAt(index);
    //       //
    //       //   _listKey.currentState?.removeItem(
    //       //     index,
    //       //     (context, animation) => _buildItem(item, index, animation),
    //       //     duration: _duration,
    //       //   );
    //       // }
    //
    //       if (_items.isEmpty) {
    //         Future.delayed(_duration, () {
    //           try {
    //             isEmptyNotifier.value = true;
    //           } catch (e) {}
    //         });
    //       }
    //     }
    //   },
    //   listenWhen: (previous, current) {
    //     return previous.list != current.list;
    //   },
    //   child: Column(
    //     children: [
    //       ValueListenableBuilder<bool>(
    //         valueListenable: isEmptyNotifier,
    //         builder: (context, isEmpty, _) {
    //           if (isEmpty) {
    //             return EmptyLandCertificateWidget();
    //           }
    //           return const SizedBox();
    //         },
    //       ),
    //       Expanded(
    //         child: AnimatedList.separated(
    //           key: _listKey,
    //           padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
    //           itemBuilder: (context, index, animation) {
    //             return _buildItem(_items[index], index, animation);
    //           },
    //           separatorBuilder: (context, index, _) {
    //             return const SizedBox(height: 16.0);
    //           },
    //           removedSeparatorBuilder: (context, index, animation) {
    //             return const SizedBox(height: 16.0);
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
                AppDialog(
                  title: LKey.delete.tr(),
                  description: LKey.messageDeleteItemConfirmDescription.tr(),
                  onConfirm: () {
                    // _removeItem(index);
                    cubit.remove(item);
                  },
                  onCancel: () {},
                ).show(context);
              },
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              icon: LineIcons.trash,
              label: LKey.delete.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
