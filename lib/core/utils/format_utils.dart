import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../index.dart';

extension AmountFormat on num {
  String displayFormat({int? decimalDigits}) {
    if (this == null) {
      return '';
    } else if (this == 0) {
      //nếu không check case này thì có thể -0
      return '0';
    }

    return NumberFormat("#,##0.###", 'en_US').format(this);
  }

  String inputFormat({int? decimalDigits}) {
    //just show number
    //if is double seprate by , at decimal
    return NumberFormat("###0.###", "en_US").format(this);
  }
}

class ThousandTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String truncated = newValue.text;
    const String dot = '.';
    const String comma = ',';

    String integer = truncated.split(dot).first.replaceAll(comma, '');

    if (integer.length > 1) {
      if (integer[0] == '0') {
        integer = integer.substring(1);
      }
    }

    String newText = splitUnit(integer).join(comma);
    if (truncated.split(dot).length > 1) {
      newText = '$newText.${truncated.split(dot).last}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.fromPosition(TextPosition(offset: newText.length)),
      composing: TextRange.empty,
    );
  }
}

List<String> splitUnit(String number) {
  int length = number.length;
  int currentIndex = length;
  List<String> results = [];
  while (currentIndex > 0) {
    int preIndex = currentIndex - 3;
    results.insert(0, number.substring(preIndex >= 0 ? preIndex : 0, currentIndex));
    currentIndex = preIndex >= 0 ? preIndex : 0;
  }
  return results;
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.isCommaToDot = true});
  final bool isCommaToDot;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    const String dot = '.';
    String newText = newValue.text;

    if (newText.length == 1 && newText == dot) {
      return TextEditingValue(
        text: '0.',
        selection: TextSelection.fromPosition(const TextPosition(offset: 2)),
        composing: TextRange.empty,
      );
    } else {
      if (newValue.text.characters.isNotEmpty) {
        if (newValue.text.characters.last == ',') {
          return TextEditingValue(
            text: '${oldValue.text}.',
            selection: newValue.selection,
            composing: newValue.composing,
          );
        }
      }
    }

    return newValue;
  }
}

///Đặt giới hạn 3 số thập phân
class DotTextInputFormatter extends TextInputFormatter {
  final int? fractionDigits;

  DotTextInputFormatter({this.fractionDigits});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String truncated = newValue.text;
    const String dot = '.';

    final fractionDigits = this.fractionDigits ?? 3;

    if (truncated.split(dot).length > 2) {
      return oldValue;
    }

    if (truncated.split(dot).length == 2) {
      if (truncated.split(dot).last.length > fractionDigits) {
        return oldValue;
      }
    }

    return newValue;
  }
}

class MinMaxNumberInputFormatter extends TextInputFormatter {
  final double? minimum;
  final double? maximum;

  MinMaxNumberInputFormatter(this.minimum, this.maximum) {
    if (maximum != null && minimum != null) {
      assert(maximum! >= minimum!);
    }
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    final String truncate = newValue.text;

    final newNumber = truncate.replaceAll(',', '').parseDouble();

    if (newNumber != null) {
      if (minimum != null && minimum! > newNumber) {
        return oldValue;
      } else if (maximum != null && maximum! < newNumber) {
        return oldValue;
      }
    }

    return newValue;
  }
}
