import 'package:flutter/material.dart';

import 'index.dart';

void AppShowDatePicker(
  BuildContext context,
  ValueChanged<DateTime?> onChanged, {
  DateTime? initialDate,
}) async {
  context.hideKeyboard();

  showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  ).then(onChanged);
}
