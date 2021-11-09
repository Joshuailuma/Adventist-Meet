import 'package:adventist_meet/components/constants.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isLightMode => themeMode == ThemeMode.light;
  bool get isSystemMode => themeMode == ThemeMode.system;

  void toogleDarkTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : null!;
    notifyListeners();
  }

  void toogleLightTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : null!;
    notifyListeners();
  }

  void toogleSystemTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.system : null!;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimaryColor,
    ),
    scaffoldBackgroundColor: Color(0xFFAA98A9).withOpacity(0.7),
    colorScheme: ColorScheme.dark(),
    errorColor: Color(0xFF36454F),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimaryColor,
    ),
    scaffoldBackgroundColor: kBackgroundColor,
    primaryColor: kPrimaryColor,
    colorScheme: ColorScheme.light(),
    errorColor: Colors.white,
    // textTheme: Theme.of(context)
    //     .textTheme
    //     .apply(bodyColor: kTextColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
