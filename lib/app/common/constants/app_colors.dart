import 'package:flutter/material.dart';

class AppColors {
  static Color hexColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }


  static const Color bgBlue1 = Color(0xFF4C8EFE);
  static const Color bgBlue2 = Color(0xFF4095E5);
  //蓝色
  static const Color textBlue = Color(0xFF4C8EFE);

  static const Color theme = Color(0xFFFAD59D);
  static const Color color_FFFAD59D = Color(0xFFFAD59D);
  //
  static const Color color_FF101010 = Color(0xFF101010);
  static const Color color_14FF6F00 = Color(0x14FF6F00);
  static const Color color_0FFF6F00 = Color(0x0FFF6F00);
  static const Color color_B3111F2C = Color(0xB3111F2C);
  static const Color color_0F111F2C = Color(0x0F111F2C);
  static const Color color_FF8D583A = Color(0xFF8D583A);
  static const Color color_8FF93A4A = Color(0x8FF93A4A);
  static const Color color_8FFF6F00 = Color(0x8FFF6F00);
  static const Color color_14F93A4A = Color(0x14F93A4A);
  static const Color color_FFF93A4A = Color(0xFFF93A4A);
  static const Color color_FFFFE9B6 = Color(0xFFFFE9B6);
  static const Color color_FFF1D299 = Color(0xFFF1D299);
  static const Color color_FF8B572A = Color(0xFF8B572A);
  static const Color color_FFFF6F00 = Color(0xFFFF6F00);
  static const Color color_FF505050 = Color(0xFF505050);
  static const Color color_FFFFEEDF = Color(0xFFFFEEDF);
  static const Color color_66FF6F00 = Color(0x66FF6F00);
  static const Color color_47111F2C = Color(0x47111F2C);
  static const Color color_0FF93A4A = Color(0x0FF93A4A);
  static const Color color_FF999999 = Color(0xFF999999);
  static const Color color_FF333333 = Color(0xFF333333);
  static const Color color_FFB2B2B2 = Color(0xFFB2B2B2);

  static const Color color_FFF5F5F5 = Color(0xFFF5F5F5);
  static const Color color_FFEDEDED = Color(0xFFEDEDED);

  static const Color color_FFAE86 = Color(0xFFFFAE86);
  static const Color color_FF1F1F1F = Color(0xFF1F1F1F);
  static const Color color_B3FFFFFF = Color(0xB3FFFFFF);
  static const Color color_FFFF3F3F = Color(0xFFFF3F3F);
  static const Color color_66FFFFFF = Color(0x66FFFFFF);


  //红色
  static const Color color_FA5151 = Color(0xFFFA5151);
  //红色
  static const Color bgRed = Color(0xFFDB2D1D);

}
