import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class AppKeyboardUtil {
  static void hide(BuildContext context) {
    FocusScope.of(context).unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void show(BuildContext context, FocusNode node) {
    FocusScope.of(context).unfocus();
    Timer(const Duration(milliseconds: 1), () {
      FocusScope.of(context).requestFocus(node);
    });
  }
}

mixin KeyboardDetector<T extends StatefulWidget> on State<T> {
  StreamSubscription<bool>? _keyboardSubscription;
  bool isKeyboardOn = false;
  final bool useDefaultKeyboardDetectorInit = true;

  @override
  void initState() {
    super.initState();
    if (useDefaultKeyboardDetectorInit) {
      initKeyboardDetector();
    }
  }

  @override
  void dispose() {
    disposeKeyboardDetector();
    super.dispose();
  }

  void initKeyboardDetector({
    Function(double)? willShowKeyboard,
    Function()? willHideKeyboard,
  }) {
    var keyboardVisibilityController = KeyboardVisibilityController();

    _keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardOn = visible;
      });

      if (visible) {
        if (willShowKeyboard != null) {
          willShowKeyboard(0.0);
        }
      } else {
        if (willHideKeyboard != null) {
          willHideKeyboard();
        }
      }
    });
  }

  void disposeKeyboardDetector() {
    _keyboardSubscription?.cancel();
  }
}