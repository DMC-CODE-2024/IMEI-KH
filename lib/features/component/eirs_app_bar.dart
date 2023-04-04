import 'package:eirs/constants/strings.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/image_path.dart';
import '../../main.dart';
import '../../theme/colors.dart';
import '../launcher/data/models/device_details_res.dart';

class EirsAppBar extends StatelessWidget with PreferredSizeWidget {
  const EirsAppBar({
    Key? key,
    this.autoImplementLeading = true,
    this.labelDetails,
    this.versionName,
    this.actions,
    this.systemUiOverlayStyle = SystemUiOverlayStyle.dark,
    required this.callback,
  }) : super(key: key);
  final Function callback;
  final bool autoImplementLeading;
  final LabelDetails? labelDetails;
  final String? versionName;
  final List<Widget>? actions;
  final SystemUiOverlayStyle systemUiOverlayStyle;

  @override
  Widget build(BuildContext context) {
    String emptyString = "";
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
        child: Text(
          labelDetails?.eirsAppHeader ?? emptyString,
          style: TextStyle(color: AppColors.secondary, fontSize: 14),
        ),
      ),
      leading: DescribedFeatureOverlay(
        featureId: feature1,
        tapTarget: Padding(
          padding: const EdgeInsets.all(30),
          child: SvgPicture.asset(ImageConstants.splashIcon),
        ),
        backgroundColor: AppColors.secondary,
        title: Text(
          labelDetails?.aboutUs ?? emptyString,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        overflowMode: feature1OverflowMode,
        enablePulsingAnimation: feature1EnablePulsingAnimation,
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(labelDetails?.knowMore ?? emptyString),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                children: [
                  Text(
                    labelDetails?.version ?? StringConstants.versionName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " $versionName",
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
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
              title: Text(
                labelDetails?.clickToWatch ?? emptyString,
                style: const TextStyle(fontWeight: FontWeight.w700),
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
              title: Text(
                labelDetails?.history ?? emptyString,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              description: Text(labelDetails?.getList ?? emptyString),
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
              title: Text(
                labelDetails?.language ?? emptyString,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              description: Text(labelDetails?.changeAppLanguage ?? emptyString),
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
