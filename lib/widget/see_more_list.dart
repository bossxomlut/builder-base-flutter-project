import 'package:flutter/material.dart';

import 'index.dart';

class SeeMoreList<T> extends StatelessWidget {
  const SeeMoreList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onSeeMore,
    this.defaultItemCount = 3,
  });

  final List<T> items;
  final Widget Function(T item, int? index) itemBuilder;
  final VoidCallback onSeeMore;
  final int defaultItemCount;

  @override
  Widget build(BuildContext context) {
    final maxItemCount = items.length > defaultItemCount ? defaultItemCount : items.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < maxItemCount; i++) itemBuilder(items[i], i),
        if (items.length > defaultItemCount)
          Align(
            alignment: Alignment.centerRight,
            child: SeeMoreWidget(
              onTap: onSeeMore,
            ),
          ),
      ],
    );
  }
}
