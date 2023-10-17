import 'package:eirs/constants/strings.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/image_path.dart';
import '../../helper/app_states_notifier.dart';
import '../../helper/shared_pref.dart';
import '../../main.dart';
import '../../theme/colors.dart';
import '../launcher/data/models/device_details_res.dart';

class EirsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const EirsAppBar(
      {Key? key,
      this.autoImplementLeading = true,
      this.labelDetails,
      this.versionName,
      this.actions,
      this.systemUiOverlayStyle = SystemUiOverlayStyle.dark,
      required this.callback})
      : super(key: key);
  final Function callback;
  final bool autoImplementLeading;
  final LabelDetails? labelDetails;
  final String? versionName;
  final List<Widget>? actions;
  final SystemUiOverlayStyle systemUiOverlayStyle;

  @override
  State<StatefulWidget> createState() {
    return _EirsAppBarState();
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _EirsAppBarState extends State<EirsAppBar> {
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    getLocale().then((languageCode) {
      switch (languageCode) {
        case StringConstants.englishCode:
          setState(() {
            isEnglish = true;
          });
          break;
        case StringConstants.khmerCode:
          setState(() {
            isEnglish = false;
          });
          break;
      }
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isEnglish = Provider.of<AppStatesNotifier>(context).languageStatus;
  }

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
      leading: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: DescribedFeatureOverlay(
          featureId: feature1,
          tapTarget: Padding(
            padding: const EdgeInsets.all(30),
            child: Image.asset(
              ImageConstants.splashIcon,
              width: 67,
              height: 40,
            ),
          ),
          backgroundColor: AppColors.secondary,
          title: Text(
            widget.labelDetails?.aboutUs ?? emptyString,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          overflowMode: feature1OverflowMode,
          enablePulsingAnimation: feature1EnablePulsingAnimation,
          description: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.labelDetails?.knowMore ?? emptyString),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    Text(
                      widget.labelDetails?.appVersion ??
                          StringConstants.appVersion,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text(
                      ": ${widget.versionName}",
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              )
            ],
          ),
          child: Transform.scale(
            scale: 1,
            child: IconButton(
              onPressed: () =>
                  widget.callback.call(AppBarActions.appLogo, isEnglish),
              icon: Image.asset(
                ImageConstants.splashIcon,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            DescribedFeatureOverlay(
              featureId: feature2,
              tapTarget: SvgPicture.asset(
                ImageConstants.infoIcon,
                width: 24,
                height: 24,
              ),
              backgroundColor: AppColors.secondary,
              contentLocation: ContentLocation.below,
              title: Text(
                widget.labelDetails?.clickToWatch ?? emptyString,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onComplete: action,
              onOpen: () async {
                return true;
              },
              child: IconButton(
                icon: SvgPicture.asset(
                  ImageConstants.infoIcon,
                  width: 24,
                  height: 24,
                ),
                onPressed: () =>
                    widget.callback.call(AppBarActions.info, isEnglish),
              ),
            ),
            DescribedFeatureOverlay(
              featureId: feature3,
              tapTarget: SvgPicture.asset(
                ImageConstants.timeIcon,
                width: 24,
                height: 24,
              ),
              backgroundColor: AppColors.secondary,
              contentLocation: ContentLocation.below,
              title: Text(
                widget.labelDetails?.history ?? emptyString,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              description: Text(widget.labelDetails?.getList ?? emptyString),
              onComplete: action,
              onOpen: () async {
                return true;
              },
              child: IconButton(
                onPressed: () =>
                    widget.callback.call(AppBarActions.history, isEnglish),
                icon: SvgPicture.asset(
                  ImageConstants.timeIcon,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            DescribedFeatureOverlay(
              featureId: feature4,
              tapTarget: Image.asset(
                isEnglish
                    ? ImageConstants.khmerIconAppbar
                    : ImageConstants.englishIconAppbar,
                width: 24,
                height: 24,
              ),
              backgroundColor: AppColors.secondary,
              contentLocation: ContentLocation.below,
              title: Text(
                widget.labelDetails?.language ?? emptyString,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              description:
                  Text(widget.labelDetails?.changeAppLanguage ?? emptyString),
              onComplete: action,
              onOpen: () async {
                return true;
              },
              child: IconButton(
                onPressed: () =>
                    widget.callback.call(AppBarActions.localization, isEnglish),
                icon: Image.asset(
                    isEnglish
                        ? ImageConstants.khmerIconAppbar
                        : ImageConstants.englishIconAppbar,
                    width: 24,
                    height: 24),
              ),
            ),
          ],
        )
      ],
      backgroundColor: Colors.white,
    );
  }
}

enum AppBarActions { localization, history, info, appLogo }
