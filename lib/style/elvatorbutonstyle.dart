import 'package:flutter/material.dart';

// 统一的按钮样式
class ButtonStyles {
  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 圆角
      ),
    );
  }
}
