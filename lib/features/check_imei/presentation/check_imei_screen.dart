import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eirs/features/component/custom_progress_indicator.dart';
import 'package:eirs/features/history/data/business_logic/device_history_bloc.dart';
import 'package:eirs/helper/app_states_notifier.dart';
import 'package:eirs/helper/connection_status_notifier.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
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
  Map _source = {ConnectivityResult.none: false};
  bool hasNetwork = false;
  final TextEditingController imeiController = TextEditingController();
  String text = "0/15";
  String emptyString = "";
  Color textColor = AppColors.grey;
  LabelDetails? labelDetails;

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
        default:
          hasNetwork = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ConnectionStatusNotifier(),
        builder: (context, Map<dynamic, dynamic> status, child) {
          updateNetworkStatus(status);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: EirsAppBar(
              labelDetails: labelDetails,
              callback: (value) {
                _appBarActions(value);
              },
            ),
            body: BlocConsumer<CheckImeiBloc, CheckImeiState>(
              builder: (context, state) {
                if (!hasNetwork) {
                  return NoInternetPage(labelDetails: labelDetails);
                }

                if (state is CheckImeiLoadingState ||
                    state is LanguageLoadingState) {
                  return const CustomProgressIndicator(textColor: Colors.black);
                }

                if (state is CheckImeiErrorState ||
                    state is LanguageErrorState) {
                  return ErrorPage(labelDetails: labelDetails);
                }

                return _imeiPageWidget();
              },
              listener: (context, state) {
                if (state is CheckImeiLoadedState) {
                  _navigateResultScreen(
                      state.checkImeiRes.result?.deviceDetails,
                      state.checkImeiRes.result?.validImei ?? false);
                }

                if (state is CheckImeiErrorState) {
                  _navigateResultScreen(null, false);
                }

                if (state is LanguageLoadedState) {
                  Provider.of<AppStatesNotifier>(context, listen: false)
                      .updateState(state.deviceDetailsRes.labelDetails);
                }
              },
            ),
          );
        });
  }

  void _navigateResultScreen(Map<String, dynamic>? data, bool isValidImei) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImeiResultScreen(
            labelDetails: labelDetails,
            scanImei: imeiController.text,
            data: data,
            isValidImei: isValidImei)));
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
            BlocProvider.of<CheckImeiBloc>(this.context)
                .add(CheckImeiInitEvent(languageType: value));
          });
        });
  }

  void _checkImei(BuildContext context) {
    String inputImei = imeiController.text;
    if (inputImei.isEmpty) return _showErrorMsg(StringConstants.emptyMsg);
    if (inputImei.length < 15) {
      return _showErrorMsg(StringConstants.minLengthError);
    }
    BlocProvider.of<CheckImeiBloc>(context)
        .add(CheckImeiInitEvent(inputImei: inputImei));
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
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScannerPage(
        labelDetails: labelDetails,
      );
    }));
  }

  Widget _imeiPageWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Flexible(
                  flex: 1,
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          keyboardType: TextInputType.number,
                          controller: imeiController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
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
                Flexible(
                  flex: 1,
                  child: Row(
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
                  ),
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
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Image.asset(ImageConstants.deviceBox),
                ),
                Flexible(
                  flex: 1,
                  child: SvgPicture.asset(ImageConstants.boxImei),
                )
              ],
            ),
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
