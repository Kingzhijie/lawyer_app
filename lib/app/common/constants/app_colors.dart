import 'package:flutter/material.dart';

class AppColors {
  static Color hexColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static const Color theme = Color(0xFF0058EA);
  static const Color color_line = Color(0x1D000000);
  static const Color color_99000000 = Color(0x99000000);
  static const Color color_E6000000 = Color(0xE6000000);
  static const Color color_white = Color(0xFFFFFFFF);
  static const Color color_66000000 = Color(0x66000000);
  static const Color color_FFC5C5C5 = Color(0xFFC5C5C5);
  static const Color color_FFF3F3F3 = Color(0xFFF3F3F3);
  static const Color color_FFF8F8F8 = Color(0xFFF8F8F8);
  static const Color color_FFDCDCDC = Color(0xFFDCDCDC);
  static const Color color_FFF3F7FF = Color(0xFFF3F7FF);
  static const Color color_FFECF2FE = Color(0xFFECF2FE);
  static const Color color_FFFEF3E6 = Color(0xFFFEF3E6);
  static const Color color_FFFDECEE = Color(0xFFFDECEE);
  static const Color color_FFE8F7F2 = Color(0xFFE8F7F2);
  static const Color color_FFEBEBF8 = Color(0xFFEBEBF8);
  static const Color color_FFFFEDEF = Color(0xFFFFEDEF);
  static const Color color_FFE34D59 = Color(0xFFE34D59);
  static const Color color_FF1F2937 = Color(0xFF1F2937);
  static const Color color_FFEEEEEE = Color(0xFFEEEEEE);
  static const Color color_42000000 = Color(0x42000000);
  static const Color color_FFF5F7FA = Color(0xFFF5F7FA);




}
