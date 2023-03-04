import 'package:eirs/constants/constants.dart';
import 'package:eirs/constants/routes.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_bloc.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../theme/colors.dart';
import '../data/business_logic/launcher_event.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key, required this.title});

  final String title;

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    /*Future.delayed(splashDuration, () {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.IMEI_INFO, (route) => false);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    LauncherBloc bloc = BlocProvider.of<LauncherBloc>(context);
    bloc.add(LauncherInitEvent());
    return Scaffold(body:
        BlocBuilder<LauncherBloc, LauncherState>(builder: (context, state) {
      if (state is LauncherLoadingState) {
        return Center(
          child: _splashWidget(),
        );
      }
      if (state is LauncherLoadedState) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.IMEI_INFO, (route) => false);
        });
        return Container();
      }
      return Container();
    }));
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
                SvgPicture.asset(ImageConstants.appIcon),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    StringConstants.appName,
                    style: TextStyle(fontSize: 24, color: AppColors.secondary),
                  ),
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
