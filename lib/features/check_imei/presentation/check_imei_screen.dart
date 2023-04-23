import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eirs/features/component/custom_progress_indicator.dart';
import 'package:eirs/features/component/imei_scan_failed_dialog.dart';
import 'package:eirs/features/history/data/business_logic/device_history_bloc.dart';
import 'package:eirs/helper/app_states_notifier.dart';
import 'package:eirs/helper/connection_status_notifier.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../helper/shared_pref.dart';
import '../../../main.dart';
import '../../../theme/colors.dart';
import '../../component/button.dart';
import '../../component/eirs_app_bar.dart';
import '../../component/error_page.dart';
import '../../component/input_borders.dart';
import '../../component/localization_dialog.dart';
import '../../component/need_any_help_widget.dart';
import '../../component/no_internet_page.dart';
import '../../history/presentation/device_history_screen.dart';
import '../../imei_result/presentation/imei_result_screen.dart';
import '../../launcher/data/models/device_details_res.dart';
import '../../scanner/data/business_logic/scanner_bloc.dart';
import '../../scanner/scanner_screen.dart';
import '../data/business_logic/check_imei_bloc.dart';
import '../data/business_logic/check_imei_state.dart';

class CheckImeiScreen extends StatefulWidget {
  const CheckImeiScreen({super.key, required this.title});

  final String title;

  @override
  State<CheckImeiScreen> createState() => _CheckImeiScreenState();
}

class _CheckImeiScreenState extends State<CheckImeiScreen> {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map _source = {ConnectivityResult.none: false};
  bool hasNetwork = true;
  final TextEditingController imeiController = TextEditingController();
  String text = "0/15";
  String versionName = "";
  String emptyString = "";
  Color textColor = AppColors.grey;
  LabelDetails? labelDetails;
  String selectedLng = StringConstants.englishCode;
  bool reloadPage = false;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      versionName = value.version;
    });
    getLocale().then((languageCode) {
      selectedLng = languageCode;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

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
    }
  }

  void _reloadPage() {
    BlocProvider.of<CheckImeiBloc>(context)
        .add(CheckImeiInitEvent(requestCode: pageRefresh));
  }

  PreferredSizeWidget _appBarWithTitle() {
    return AppBar(
      backgroundColor: Colors.white,
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
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(ImageConstants.splashIcon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ConnectionStatusNotifier(),
        builder: (context, Map<dynamic, dynamic> status, child) {
          updateNetworkStatus(status);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: hasNetwork
                ? EirsAppBar(
                    labelDetails: labelDetails,
                    versionName: versionName,
                    callback: (value) {
                      _appBarActions(value);
                    },
                  )
                : _appBarWithTitle(),
            body: BlocConsumer<CheckImeiBloc, CheckImeiState>(
              builder: (context, state) {
                if (!hasNetwork) {
                  return NoInternetPage(
                      labelDetails: labelDetails,
                      callback: (value) {
                        _reloadPage();
                      });
                }
                if (state is CheckImeiLoadingState ||
                    state is LanguageLoadingState) {
                  return CustomProgressIndicator(
                      labelDetails: labelDetails, textColor: Colors.black);
                }

                if (state is CheckImeiErrorState ||
                    state is LanguageErrorState) {
                  return ErrorPage(
                      labelDetails: labelDetails,
                      callback: (value) {
                        _reloadPage();
                      });
                }

                return _imeiPageWidget();
              },
              listener: (context, state) {
                if (state is CheckImeiLoadedState) {
                  _navigateResultScreen(
                      state.checkImeiRes.result?.deviceDetails,
                      state.checkImeiRes.result?.validImei ?? false);
                }

                if (state is LanguageLoadedState) {
                  selectedLng = state.deviceDetailsRes.languageType ??
                      StringConstants.englishCode;
                  Provider.of<AppStatesNotifier>(context, listen: false)
                      .updateState(state.deviceDetailsRes.labelDetails);
                }
              },
            ),
          );
        });
  }

  void _navigateResultScreen(Map<String, dynamic>? data, bool isValidImei) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ImeiResultScreen(
                labelDetails: labelDetails,
                scanImei: imeiController.text,
                data: data,
                isValidImei: isValidImei)))
        .then((value) {
      if (value == true) {
        setState(() {
          imeiController.clear();
          text = "0/15";
          textColor = AppColors.grey;
        });
      }
    });
  }

  void _appBarActions(AppBarActions values) {
    switch (values) {
      case AppBarActions.localization:
        _showLocalizationDialog();
        break;
      case AppBarActions.history:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: DeviceHistoryBloc(),
              child: const DeviceHistoryScreen(),
            ),
          ),
        );
        break;
      case AppBarActions.info:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FeatureDiscovery.discoverFeatures(
            context,
            const <String>{feature1, feature2, feature3, feature4, feature5},
          );
        });
        break;
    }
  }

  void _showLocalizationDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return LocalizationDialog(callback: (value) {
            if (hasNetwork && value != selectedLng) {
              BlocProvider.of<CheckImeiBloc>(this.context).add(
                  CheckImeiInitEvent(
                      languageType: value, requestCode: languageReq));
            }
          });
        });
  }

  void _showImeiFailedDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return ImeiScanFailedDialog(
            callback: () {
              _startScanner();
            },
          );
        });
  }

  void _checkImei(BuildContext context) {
    String inputImei = imeiController.text;
    if (inputImei.isEmpty) {
      return _showErrorMsg(labelDetails?.feildNotEmpty ?? emptyString);
    }
    if (inputImei.length < 15) {
      return _showErrorMsg(labelDetails?.min15Digit ?? emptyString);
    }
    BlocProvider.of<CheckImeiBloc>(context).add(CheckImeiInitEvent(
        inputImei: inputImei,
        languageType: selectedLng,
        requestCode: checkImeiReq));
  }

  void _showErrorMsg(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        errorMsg,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    ));
  }

  Future<void> _startScanner() async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: ScannerBloc(),
        child: const FeatureDiscovery.withProvider(
            persistenceProvider: NoPersistenceProvider(),
            child: ScannerPage()),
      ),
    )).then((value) {
      if (value == true) {
        _showImeiFailedDialog();
      }
    });
  }

  Widget _imeiPageWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelDetails?.getIMEIInfo ?? emptyString,
              style: TextStyle(fontSize: 20, color: AppColors.secondary),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 5),
              child: Text(labelDetails?.enterIMEI ?? emptyString,
                  style: const TextStyle(fontSize: 14, color: Colors.black)),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          onChanged: (value) => {
                            setState(() {
                              if (value.length == 15) textColor = Colors.green;
                              text = "${value.length}/15";
                            })
                          },
                          enableInteractiveSelection: true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          cursorHeight: 20,
                          style: const TextStyle(fontSize: 14),
                          keyboardType: TextInputType.number,
                          controller: imeiController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              filled: true,
                              hintText: labelDetails?.enterFifteenDigit ??
                                  emptyString,
                              hintStyle: const TextStyle(fontSize: 10),
                              fillColor: Colors.white70,
                              enabledBorder: InputBorders.enabled,
                              errorBorder: InputBorders.error,
                              focusedErrorBorder: InputBorders.error,
                              border: InputBorders.border,
                              focusedBorder: InputBorders.focused),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            text,
                            style: TextStyle(fontSize: 10, color: textColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        labelDetails?.or ?? emptyString,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: DescribedFeatureOverlay(
                        featureId: feature5,
                        tapTarget: SvgPicture.asset(ImageConstants.scanIcon),
                        backgroundColor: AppColors.secondary,
                        contentLocation: ContentLocation.below,
                        title: Text(
                          labelDetails?.scanIMEI ?? emptyString,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        description:
                            Text(labelDetails?.canBeBarcode ?? emptyString),
                        onOpen: () async {
                          return true;
                        },
                        child: GestureDetector(
                          onTap: () => _startScanner(),
                          child: Column(
                            children: [
                              SvgPicture.asset(ImageConstants.scanIcon),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  labelDetails?.scanBar ?? emptyString,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: AppButton(
                isLoading: false,
                child: Text(labelDetails?.checkIMEI ?? emptyString),
                onPressed: () => _checkImei(context),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  labelDetails?.findImei ?? emptyString,
                  style: TextStyle(color: AppColors.secondary, fontSize: 14.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: Text(
                labelDetails?.optionA ?? emptyString,
                style: TextStyle(color: AppColors.buttonColor, fontSize: 14.0),
              ),
            ),
            Text(
              labelDetails?.imeiAlsoWrittenInBox ?? emptyString,
              style: TextStyle(color: AppColors.black, fontSize: 14.0),
            ),
            Image.asset(ImageConstants.optionA),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                labelDetails?.or ?? emptyString,
                style: TextStyle(fontSize: 14, color: AppColors.greyTextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                labelDetails?.optionB ?? emptyString,
                style: TextStyle(color: AppColors.buttonColor, fontSize: 14.0),
              ),
            ),
            Text(
              labelDetails?.dial ?? emptyString,
              style: TextStyle(color: AppColors.black, fontSize: 14.0),
            ),
            Image.asset(ImageConstants.deviceInfo),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: NeedAnyHelpWidget(
                labelDetails: labelDetails,
              ),
            )
          ],
        ),
      ),
    );
  }
}
