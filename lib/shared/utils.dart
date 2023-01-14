import 'package:flutter/material.dart';

class Utils {
  static final messageKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? message) {
    if (message == null) return;
    final snackBar = SnackBar(
        content: Text(message), duration: const Duration(milliseconds: 4000));

    messageKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
