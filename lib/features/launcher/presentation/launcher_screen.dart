import 'package:eirs/constants/constants.dart';
import 'package:eirs/constants/image_path.dart';
import 'package:eirs/constants/routes.dart';
import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_bloc.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_state.dart';
import 'package:eirs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) {
    //     Future.delayed(splashDuration, () {
    //       Navigator.of(context).pushNamed(Routes.IMEI_INFO);
    //     });
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    LauncherBloc bloc = BlocProvider.of<LauncherBloc>(context);
    bloc.add(LauncherInitEvent());
    return Scaffold(
        body: Column(
      children: <Widget>[
        BlocBuilder<LauncherBloc, LauncherState>(builder: (context, state) {
          if (state is LauncherLoadingState) {
            print("invoke 3");
          }
          return Container();
        }),
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
    ));
  }
}
