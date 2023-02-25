import 'dart:ui';

import 'package:eirs/theme/hex_color.dart';

class AppColors {
  const AppColors._();

  static const primary = Color(0xff333333);
  static Color secondary = HexColor('#1E4076');

  static const info = Color(0xFF2277FE);
  static const success = Color(0xFF53D1B6);
  static const warning = Color(0xFFFFC833);
  static const error = Color(0xFFC94F59);

  static Color black = HexColor('#000000');
  static const description = Color(0xFF9CA5BF);
  static const white = Color(0xFFFFFFFF);
  
  static Color greyTextColor = HexColor('#828282');
  static Color appBarTextColor = HexColor('#4F4F4F');
  static Color grey = HexColor('#BDBDBD');
  static Color buttonColor = HexColor('#EE7C23');
  static Color dialogBg = HexColor('#F2F2F2');
}