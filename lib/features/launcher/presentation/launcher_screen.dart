import 'package:eirs/constants/routes.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_bloc.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../helper/shared_pref.dart';
import '../../../theme/colors.dart';
import '../data/business_logic/launcher_event.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key, required this.title});

  final String title;

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  String selectedLanguage = StringConstants.englishCode;

  @override
  void initState() {
    super.initState();
    getLocale().then((locale) {
      selectedLanguage = locale.languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    LauncherBloc bloc = BlocProvider.of<LauncherBloc>(context);
    bloc.add(LauncherInitEvent(languageType: selectedLanguage));
    return Scaffold(
      body: BlocConsumer<LauncherBloc, LauncherState>(
        builder: (context, state) {
          if (state is LauncherLoadingState) {
            return Center(
              child: _splashWidget(),
            );
          }
          if (state is LauncherLoadedState) {
            return Container();
          }
          return Container();
        },
        listener: (context, state) {
          if (state is LauncherLoadedState) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.IMEI_SCREEN, (route) => false);
          }
        },
      ),
    );
  }

  Widget _splashWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageConstants.splashIcon),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                  child: Text(StringConstants.splashTitle,
                      style:
                          TextStyle(fontSize: 24, color: AppColors.secondary),
                      textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                StringConstants.splashCopyRightText,
                style: TextStyle(fontSize: 14, color: AppColors.greyTextColor),
              )),
        ),
      ],
    );
  }
}
