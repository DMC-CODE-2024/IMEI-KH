import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/image_path.dart';
import '../../main.dart';
import '../../theme/colors.dart';

class EirsAppBar extends StatelessWidget with PreferredSizeWidget {
  const EirsAppBar({
    Key? key,
    this.autoImplementLeading = true,
    this.title,
    this.actions,
    this.systemUiOverlayStyle = SystemUiOverlayStyle.dark,
    required this.callback,
  }) : super(key: key);
  final Function callback;
  final bool autoImplementLeading;
  final String? title;
  final List<Widget>? actions;
  final SystemUiOverlayStyle systemUiOverlayStyle;

  @override
  Widget build(BuildContext context) {
    var feature1OverflowMode = OverflowMode.clipContent;
    var feature1EnablePulsingAnimation = false;

    final action = () async {
      print('IconButton of $feature7 tapped.');
      return true;
    };
    return AppBar(
      elevation: 1,
      centerTitle: false,
      titleSpacing: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: (title != null)
            ? Text(
                title!,
                style: TextStyle(color: AppColors.secondary, fontSize: 14),
              )
            : const Spacer(),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(ImageConstants.appIcon),
        ),
      ),
      actions: <Widget>[
          Row(
          children: [
            IconButton(
                onPressed: () => callback.call(AppBarActions.info),
                icon: SvgPicture.asset(ImageConstants.infoIcon)),
            IconButton(
                onPressed: () => callback.call(AppBarActions.history),
                icon: SvgPicture.asset(ImageConstants.timeIcon)),
            InkWell(
              onTap: () => callback.call(AppBarActions.localization),
              child: IconButton(
                onPressed: () => callback.call(AppBarActions.localization),
                icon: Image.asset(
                  ImageConstants.localizationIcon,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        )
      ],
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

enum AppBarActions { localization, history, info }
