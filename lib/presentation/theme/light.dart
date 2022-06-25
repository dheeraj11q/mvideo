import 'package:flutter/material.dart';

const Color primaryColor = Color(0xffec3570);

ThemeData themeLight = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.black)),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(primary: primaryColor, secondary: primaryColor),
);
