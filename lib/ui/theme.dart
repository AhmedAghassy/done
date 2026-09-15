import 'package:done/services/theme_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color orangeClr = Color(0xCFFF8746);
const Color redClr = Colors.red;
const Color white = Colors.white;
const primaryClr = Colors.teal;
const Color darkBodyBackground = Color(0xFF424242);
const Color darkGreyClr = Color(0xFF121212);
const Color grey = Colors.grey;
final redClr400 = Colors.red[400];
final grey100 = Colors.grey[100];
final grey700 = Colors.grey[700];

class Themes {
  static final _themeServices = ThemeServices();

  // en
  static final lightEn = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: white,
      elevation: 0,
      titleTextStyle: GoogleFonts.lato(fontSize: 20, color: darkGreyClr),
    ),
    textTheme: GoogleFonts.latoTextTheme(),
    colorSchemeSeed: primaryClr,
    scaffoldBackgroundColor: white,
    secondaryHeaderColor: white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryClr,
      foregroundColor: darkGreyClr,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(darkGreyClr),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
  );

  static final darkEn = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: darkGreyClr,
      elevation: 0,
      titleTextStyle: GoogleFonts.lato(fontSize: 20, color: white),
    ),
    textTheme: GoogleFonts.latoTextTheme(),
    colorSchemeSeed: primaryClr,
    scaffoldBackgroundColor: darkGreyClr,
    secondaryHeaderColor: darkBodyBackground,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryClr,
      foregroundColor: white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(white),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
  );

  // ar
  static final lightAr = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: white,
      elevation: 0,
      titleTextStyle: GoogleFonts.elMessiri(fontSize: 20, color: darkGreyClr),
    ),
    textTheme: GoogleFonts.elMessiriTextTheme(),
    colorSchemeSeed: primaryClr,
    scaffoldBackgroundColor: white,
    secondaryHeaderColor: white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryClr,
      foregroundColor: darkGreyClr,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(darkGreyClr),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
  );

  static final darkAr = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: darkGreyClr,
      elevation: 0,
      titleTextStyle: GoogleFonts.elMessiri(fontSize: 20, color: white),
    ),
    textTheme: GoogleFonts.elMessiriTextTheme(),
    colorSchemeSeed: primaryClr,
    scaffoldBackgroundColor: darkGreyClr,
    secondaryHeaderColor: darkBodyBackground,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryClr,
      foregroundColor: white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(white),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
  );

  // styles
  static TextStyle get bigHeadingStyle {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: _themeServices.themeMode == ThemeMode.dark ? white : darkGreyClr,
    );
  }

  static TextStyle get headingStyle {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: _themeServices.themeMode == ThemeMode.dark ? white : darkGreyClr,
    );
  }

  static TextStyle get subHeadingStyle {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: _themeServices.themeMode == ThemeMode.dark ? white : darkGreyClr,
    );
  }

  static TextStyle get bodyTitleStyle {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: _themeServices.themeMode == ThemeMode.dark ? white : darkGreyClr,
    );
  }

  static TextStyle get bodySubTitleStyle {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: _themeServices.themeMode == ThemeMode.dark ? white : darkGreyClr,
    );
  }

  static TextStyle get hintFieldStyle {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: grey,
    );
  }

  static TextStyle get dateStyle {
    //const lato
    return GoogleFonts.lato(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: grey,
    );
  }

  static TextStyle get dayStyle {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: grey,
    );
  }

  static TextStyle get monthStyle {
    return const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: grey,
    );
  }

  static TextStyle get taskStateStyle {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: white,
    );
  }

  static TextStyle get taskTimeStyle {
    return TextStyle(fontSize: 12, color: grey100);
  }

  static TextStyle get taskTitleStyle {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: white,
    );
  }

  static TextStyle get taskNoteStyle {
    return TextStyle(fontSize: 13, color: grey100);
  }

  static TextStyle get dropDownStyleEn {
    return GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: _themeServices.themeMode == ThemeMode.dark ? white : darkGreyClr,
    );
  }

  static TextStyle get dropDownStyleAr {
    return GoogleFonts.elMessiri(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: _themeServices.themeMode == ThemeMode.dark ? white : darkGreyClr,
    );
  }

  static TextStyle get bodyTitleRedStyle {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: redClr,
    );
  }

  static TextStyle get batteryLevelStyle {
    return GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: _themeServices.themeMode == ThemeMode.dark ? white : darkGreyClr,
    );
  }
}
