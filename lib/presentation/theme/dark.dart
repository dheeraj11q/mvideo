import 'package:flutter/material.dart';

const Color primaryColor = Colors.black;

ThemeData themeDark = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.grey,
  textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.white)),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(primary: primaryColor, secondary: primaryColor),
);
