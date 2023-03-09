import 'package:eirs/constants/strings.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/foundation.dart';
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
    var feature1EnablePulsingAnimation = true;

    action() async {
      if (kDebugMode) {
        print('IconButton of $feature5 tapped.');
      }
      return true;
    }

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
      leading: DescribedFeatureOverlay(
        featureId: feature1,
        tapTarget: Padding(
          padding: const EdgeInsets.all(30),
          child: SvgPicture.asset(ImageConstants.splashIcon),
        ),
        backgroundColor: AppColors.secondary,
        title: const Text(
          StringConstants.aboutUs,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        overflowMode: feature1OverflowMode,
        enablePulsingAnimation: feature1EnablePulsingAnimation,
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(StringConstants.aboutUsDesc),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SvgPicture.asset(ImageConstants.splashIcon),
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            DescribedFeatureOverlay(
              featureId: feature2,
              tapTarget: SvgPicture.asset(ImageConstants.infoIcon),
              backgroundColor: AppColors.secondary,
              contentLocation: ContentLocation.below,
              title: const Text(
                StringConstants.infoTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onComplete: action,
              onOpen: () async {
                return true;
              },
              child: IconButton(
                icon: SvgPicture.asset(ImageConstants.infoIcon),
                onPressed: () => callback.call(AppBarActions.info),
              ),
            ),
            DescribedFeatureOverlay(
              featureId: feature3,
              tapTarget: SvgPicture.asset(ImageConstants.timeIcon),
              backgroundColor: AppColors.secondary,
              contentLocation: ContentLocation.below,
              title: const Text(
                StringConstants.history,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              description: const Text(StringConstants.historyDesc),
              onComplete: action,
              onOpen: () async {
                return true;
              },
              child: IconButton(
                onPressed: () => callback.call(AppBarActions.history),
                icon: SvgPicture.asset(ImageConstants.timeIcon),
              ),
            ),
            DescribedFeatureOverlay(
              featureId: feature4,
              tapTarget: SvgPicture.asset(ImageConstants.localizationIcon),
              backgroundColor: AppColors.secondary,
              contentLocation: ContentLocation.below,
              title: const Text(
                StringConstants.language,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              description: const Text(StringConstants.languageDesc),
              onComplete: action,
              onOpen: () async {
                return true;
              },
              child: IconButton(
                onPressed: () => callback.call(AppBarActions.localization),
                icon: SvgPicture.asset(ImageConstants.localizationIcon),
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
