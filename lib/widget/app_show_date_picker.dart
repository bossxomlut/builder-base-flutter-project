import 'package:flutter/material.dart';

import 'index.dart';

void AppShowDatePicker(BuildContext context, ValueChanged<DateTime?> onChanged) async {
  context.hideKeyboard();

  showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  ).then(onChanged);
}
