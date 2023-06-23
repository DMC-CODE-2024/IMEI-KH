import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/image_path.dart';
import '../../theme/colors.dart';
import 'eirs_app_bar.dart';

class ResultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResultAppBar(
      {Key? key,
      this.autoImplementLeading = true,
      this.title,
      this.actions,
      this.systemUiOverlayStyle = SystemUiOverlayStyle.dark,
      required this.callback,
      this.backButtonCallBack})
      : super(key: key);
  final Function callback;
  final VoidCallback? backButtonCallBack;
  final bool autoImplementLeading;
  final String? title;
  final List<Widget>? actions;
  final SystemUiOverlayStyle systemUiOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      centerTitle: false,
      titleSpacing: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: backButtonCallBack ?? () => Navigator.pop(context),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: (title != null)
            ? Text(
                title!,
                style: TextStyle(color: AppColors.black, fontSize: 20),
              )
            : const Spacer(),
      ),
      actions: [
        Row(
          children: [
            IconButton(
                onPressed: () => callback.call(AppBarActions.history),
                icon: SvgPicture.asset(ImageConstants.timeIcon)),
          ],
        )
      ],
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
