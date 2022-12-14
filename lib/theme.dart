import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> setLightTheme() async {
    isLight = true;
    primaryColor = const Color(0xfff43f5e);

    backgroundColor = const Color(0xfff1f5f9);
    secondryBackgroundColor = const Color(0xffFFFFFF);
    textColor = const Color(0xff000000);
    iconColor = const Color(0xffFFFFFF);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("light", true);

    notifyListeners();
  }

  Future<void> setDarkTheme() async {
    isLight = false;
    primaryColor = const Color(0xff385FEF);
    backgroundColor = const Color(0xff02132D);
    secondryBackgroundColor = const Color(0xff011b3c);
    textColor = const Color(0xffffffff);
    iconColor = const Color(0xffFFFFFF);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("light", false);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("light") == null) {
      await setLightTheme();
    } else if (prefs.getBool("light") == true) {
      await setLightTheme();
    } else if (prefs.getBool("light") == false) {
      await setDarkTheme();
    } else {
      await setLightTheme();
    }
  }
}
