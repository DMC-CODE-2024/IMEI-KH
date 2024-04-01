import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/image_path.dart';

PreferredSizeWidget appBarWithIconOnly(Function callback) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 1,
    centerTitle: false,
    leadingWidth: 95,
    leading: Padding(
      padding: const EdgeInsets.only(left: 28),
      child: GestureDetector(
        onTap: () => callback.call(),
        child: Transform.scale(
          scale: 1.6,
          child: Image.asset(
            ImageConstants.aboutUs,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}