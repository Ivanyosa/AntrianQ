import 'package:flutter/material.dart';

class AppShadow {
  AppShadow._();

  static List<BoxShadow> get soft => [
    BoxShadow(
      color: Colors.black.withOpacity(.05),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Colors.black.withOpacity(.08),
      blurRadius: 25,
      offset: const Offset(0, 10),
    ),
  ];
}
