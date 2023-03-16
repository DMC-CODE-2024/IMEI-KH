import 'dart:ui';

import 'package:eirs/theme/hex_color.dart';
import 'package:flutter/material.dart';

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
  static Color needAnyHelpBg = HexColor("#F1D8C5");
  static Color historyBg = HexColor("#EFF5FF");
  static Color historyTxtColor = HexColor("#49454F");
  static Color dateTimeTxtColor = HexColor("#828282");
  static Color validBg = HexColor("#F2FFF8");
  static Color inVlidBg = HexColor("#FFF2F2");

  static Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };
  static MaterialColor primaryColor = MaterialColor(0xff333333, color);
}