import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appTheme = ChangeNotifierProvider.autoDispose<AppTheme>(
  (ref) => AppTheme(),
);

class AppTheme extends ChangeNotifier {
  bool isLight = true;
  Color primaryColor = const Color(0xfff43f5e);

  Color backgroundColor = const Color(0xfff1f5f9);
  Color secondryBackgroundColor = const Color(0xffFFFFFF);
  Color textColor = const Color(0xff000000);

  Color iconColor = const Color(0xffFFFFFF);

  void setLightTheme() {
    isLight = true;
    primaryColor = const Color(0xfff43f5e);

    backgroundColor = const Color(0xfff1f5f9);
    secondryBackgroundColor = const Color(0xffFFFFFF);
    textColor = const Color(0xff000000);
    iconColor = const Color(0xffFFFFFF);

    notifyListeners();
  }

  void setDarkTheme() {
    isLight = false;
    primaryColor = const Color(0xff385FEF);
    backgroundColor = const Color(0xff02132D);
    secondryBackgroundColor = const Color(0xff011b3c);
    textColor = const Color(0xffffffff);
    iconColor = const Color(0xffFFFFFF);

    notifyListeners();
  }

  static const Color lightBackgroundColor = Color(0xfff1f5f9);

  static const Color darkBackgroundColor = Color(0xfff1f5f9);

  static final Color _iconColor = Colors.blueAccent.shade200;
  static const Color _lightPrimaryColor = Color(0xFF546E7A);
  static const Color _lightPrimaryVariantColor = Color(0xFF546E7A);
  static const Color _lightSecondaryColor = Colors.green;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryColor = Colors.white24;
  static const Color _darkPrimaryVariantColor = Colors.black;
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            color: _darkSecondaryColor,
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            fontSize: 26),
        color: _lightPrimaryVariantColor,
        iconTheme: IconThemeData(color: _lightOnPrimaryColor),
      ),
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        onPrimary: _lightOnPrimaryColor,
      ),
      iconTheme: IconThemeData(
        color: _iconColor,
      ),
      textTheme: _lightTextTheme,
      dividerTheme: const DividerThemeData(color: Colors.black12));

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: _darkPrimaryVariantColor,
      appBarTheme: const AppBarTheme(
        color: _darkPrimaryVariantColor,
        iconTheme: IconThemeData(color: _darkOnPrimaryColor),
      ),
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        onPrimary: _darkOnPrimaryColor,
        background: Colors.white12,
      ),
      iconTheme: IconThemeData(
        color: _iconColor,
      ),
      textTheme: _darkTextTheme,
      dividerTheme: const DividerThemeData(color: Colors.black));

  static const TextTheme _lightTextTheme = TextTheme(
    headline1: _lightScreenHeading1TextStyle,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline1: _darkScreenHeading1TextStyle,
  );

  static const TextStyle _lightScreenHeading1TextStyle = TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: _lightOnPrimaryColor,
      fontFamily: "Roboto");

  static final TextStyle _darkScreenHeading1TextStyle =
      _lightScreenHeading1TextStyle.copyWith(color: _darkOnPrimaryColor);
}
