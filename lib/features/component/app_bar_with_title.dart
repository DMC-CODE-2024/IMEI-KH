import 'package:flutter/material.dart';

class AppBarWithTitleOnly extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithTitleOnly(
      {Key? key,
      this.title,
      this.titleColor = Colors.black,
      this.iconColor = Colors.black,
      this.bgColor = Colors.white})
      : super(key: key);
  final String? title;
  final Color? titleColor;
  final Color? iconColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      iconTheme: IconThemeData(
        color: iconColor ?? Colors.black, //change your color here
      ),
      title: Text(
        title ?? "",
        style: TextStyle(color: titleColor ?? Colors.black),
      ),
      backgroundColor: bgColor ?? Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
