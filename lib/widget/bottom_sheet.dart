import 'package:flutter/material.dart';

import 'index.dart';

mixin ShowBottomSheet<T> on Widget {
  Future<T?> show(BuildContext context, {bool showDragHandle = true}) {
    context.hideKeyboard();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: showDragHandle,
      useSafeArea: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: this,
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }
}
