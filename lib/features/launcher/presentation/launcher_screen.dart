import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eirs/constants/constants.dart';
import 'package:eirs/features/component/error_page.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_bloc.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_state.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/helper/connection_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../constants/image_path.dart';
import '../../../constants/routes.dart';
import '../../../helper/app_states_notifier.dart';
import '../../../main.dart';
import '../../../theme/colors.dart';
import '../../component/no_internet_page.dart';
import '../data/business_logic/launcher_event.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key, required this.title});

  final String title;

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen>
    with SingleTickerProviderStateMixin {
  Map _source = {ConnectivityResult.none: false};
  bool hasNetwork = true;
  bool isDeviceDetailReqInvoked = false;
  String? deviceDetails;
  late AnimationController _controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    animation = Tween<Offset>(
      begin: const Offset(-0.58, 0.0),
      end: const Offset(-0.4, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
  }

  // Request for pre-init api
  Future<void> _preInitApiReq() async {
    BlocProvider.of<LauncherBloc>(context).add(LauncherInitEvent(
        requestCode: preInitReqCode,
        languageType: selectedLng,
        deviceDetails: deviceDetails));
  }

  // Request for init api
  Future<void> _initApiReq() async {
    LauncherBloc bloc = BlocProvider.of<LauncherBloc>(context);
    bloc.add(LauncherInitEvent(
        requestCode: initReqCode,
        languageType: selectedLng,
        deviceDetails: deviceDetails));
  }

  // Checking wifi or internet connectivity status
  void updateNetworkStatus(Map<dynamic, dynamic> source) async {
    _source = source;
    if (_source.isNotEmpty) {
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          hasNetwork = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.wifi:
          hasNetwork = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.none:
          hasNetwork = false;
          break;
      }
      if (hasNetwork && !isDeviceDetailReqInvoked) {
        isDeviceDetailReqInvoked = true;
        _preInitApiReq();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConnectionStatusNotifier(),
      builder:
          (BuildContext context, Map<dynamic, dynamic> value, Widget? child) {
        updateNetworkStatus(value);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              bottom: true,
              child: BlocConsumer<LauncherBloc, LauncherState>(
                builder: (context, state) {
                  if (!hasNetwork) {
                    return NoInternetPage(
                        labelDetails: LabelDetails(),
                        callback: (value) {
                          setState(() {});
                        });
                  }

                  if (state is LauncherPreInitLoadingState) {
                    return Center(child: _splashWidget(LabelDetails()));
                  } else if (state is LauncherPreInitLoadedState) {
                    return Center(child: _splashWidget(LabelDetails()));
                  } else if (state is LauncherPreInitErrorState) {
                    //Rendering error page in case of any error
                    return ErrorPage(
                        labelDetails: LabelDetails(),
                        callback: (value) {
                          _initApiReq();
                        });
                  } else if (state is LauncherLoadingState) {
                    return Center(
                      child: _splashWidget(LabelDetails()),
                    );
                  } else if (state is LauncherErrorState) {
                    return ErrorPage(
                        labelDetails: LabelDetails(),
                        callback: (value) {
                          _initApiReq();
                        });
                  } else if (state is LauncherLoadedState) {
                    return Center(
                        child:
                            _splashWidget(state.deviceDetailsRes.labelDetails));
                  }
                  return Center(child: _splashWidget(LabelDetails()));
                },
                listener: (context, state) {
                  if (state is LauncherPreInitLoadedState) {
                    _initApiReq();
                  }
                  if (state is LauncherLoadedState) {
                    Future.delayed(const Duration(seconds: 2), () {
                      //After getting label details updating current label details based on selected language
                      Provider.of<AppStatesNotifier>(context, listen: false)
                          .updateState(state.deviceDetailsRes.labelDetails);
                      //Navigate to home screen after getting success response from init api
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.IMEI_SCREEN, (route) => false);
                    });
                  }
                },
              )),
        );
      },
    );
  }

  // Launcher screen view
  Widget _splashWidget(LabelDetails? labelDetails) {
    var window = MediaQuery.of(context).size;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            ImageConstants.splashIcon,
            fit: BoxFit.contain,
            width: 170,
            height: 210,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 75, right: 75, bottom: 15, top: 0),
              child: Text(
                textAlign: TextAlign.center,
                labelDetails?.copyRight ?? "",
                style: TextStyle(fontSize: 14, color: AppColors.greyTextColor),
              )),
        ),
        patternUp(window),
        patternDown(window),
      ],
    );
  }

  // Upper side slide animation
  patternUp(Size window) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SlideTransition(
        position: animation,
        transformHitTests: true,
        textDirection: TextDirection.ltr,
        child: SizedBox(
          child: Image.asset(
            ImageConstants.patternUp,
            width: 400,
            height: window.height / 2 - 120,
          ),
        ),
      ),
    );
  }

  // Lower side slide animation
  patternDown(Size window) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: SlideTransition(
          position: animation,
          transformHitTests: true,
          textDirection: TextDirection.rtl,
          child: SizedBox(
            child: Image.asset(
              ImageConstants.patternDown,
              width: 400,
              height: window.height / 2 - 120,
            ),
          ),
        ),
      ),
    );
  }
}
