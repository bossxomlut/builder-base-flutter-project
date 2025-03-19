import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/persistence/simple_key_value_storage.dart';
import '../injection/injection.dart';

class ThemeUtils {
  static ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  static void toggleThemeMode() {
    final ThemeMode themeMode = themeModeNotifier.value;
    themeModeNotifier.value = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Save theme mode to local storage
    SimpleStorage simpleStorage = getIt.get<SimpleStorage>();

    simpleStorage.saveString('theme_mode', themeModeNotifier.value.toString());
  }

  static Future<void> initThemeMode() async {
    SimpleStorage simpleStorage = getIt.get<SimpleStorage>();
    String? themeMode = await simpleStorage.getString('theme_mode');

    if (themeMode == null) {
      themeModeNotifier.value = ThemeMode.system;
    } else {
      themeModeNotifier.value = themeMode == 'ThemeMode.light' ? ThemeMode.light : ThemeMode.dark;
    }
  }

  static ThemeData get lightTheme {
    final lightTheme = ThemeData.light();
    return lightTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(lightTheme.textTheme),
      scaffoldBackgroundColor: Color(0xFFfafbfe),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: Color(0xFFfafbfe),
      ),
      cardColor: Color(0xFFFFFFFF),
      canvasColor: Color(0xFFFFFFFF),
      cardTheme: lightTheme.cardTheme.copyWith(
        color: Color(0xFFFFFFFF),
      ),
      // colorScheme: lightTheme.colorScheme.copyWith(
      //   onSurface: Color(0xFFFFFFFF),
      // ),
      bottomSheetTheme: lightTheme.bottomSheetTheme.copyWith(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      dialogTheme: lightTheme.dialogTheme.copyWith(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      dialogBackgroundColor: Color(0xFFFFFFFF),
      timePickerTheme: lightTheme.timePickerTheme.copyWith(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      datePickerTheme: lightTheme.datePickerTheme.copyWith(
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
  }

  static ThemeData get darkTheme {
    final darkTheme = ThemeData.dark();
    return darkTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(darkTheme.textTheme),
    );
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get appTheme {
    return Theme.of(this);
  }
}

extension ThemeDataExtension on ThemeData {
  Color get borderColor => colorScheme.onSurface.withOpacity(0.12);

  Color getWarningByCountDate(int dateCount) {
    if (dateCount <= 0) {
      return Color(0xFFFF3E41);
    } else if (dateCount <= 3) {
      return Color(0xFFFFC402);
    } else if (dateCount <= 10) {
      return Color(0xFF8AD3FF);
    }

    return Colors.transparent;
  }

  TextStyle? getWarningTextStyle(int dateCount) {
    final textStyle = textTheme.bodyMedium?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 18 / 14,
      wordSpacing: 18 / 14,
    );
    if (dateCount <= 0) {
      return textStyle?.copyWith(
        color: Colors.white,
      );
    }

    return textStyle;
  }

  Color get successColor {
    return Colors.greenAccent;
  }

  ///Card colors
  Color get cerCardColor {
    return Color(0xFFFFFBFB);
  }

  Color get cerCardBorderColor {
    return Color(0xFFFFB8D1);
  }

  TextStyle? get cerNameStyle {
    return textTheme.titleMedium?.copyWith(
      fontSize: 22,
      height: 28 / 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
      wordSpacing: 10 / 22,
      color: Color(0xFFD00049),
    );
  }

  TextStyle? get cerTitleStyle {
    return textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 18 / 14,
      wordSpacing: 18 / 14,
      color: Color(0xFFAAAAAA),
    );
  }

  TextStyle? get cerValueStyle {
    return textTheme.bodyMedium?.copyWith(
      fontSize: 16,
      height: 18 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      wordSpacing: 5 / 16,
      color: Color(0xFF333333),
    );
  }

  TextStyle? get provinceStyle {
    return textTheme.bodyMedium?.copyWith(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
      wordSpacing: 10 / 28,
      color: Color(0xFF005DDF),
    );
  }

  TextStyle? get totalCerStyle {
    return textTheme.bodyMedium?.copyWith(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      wordSpacing: 10 / 16,
      color: Color(0xFF005DDF),
      decoration: TextDecoration.underline,
      decorationColor: Color(0xFF005DDF),
    );
  }

  TextStyle? get headingStyle {
    return textTheme.bodyMedium?.copyWith(
      fontSize: 34,
      height: 40 / 34,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
      wordSpacing: 10 / 34,
      color: Color(0xFF333333),
    );
  }
}
