import 'package:eirs/features/component/custom_progress_indicator.dart';
import 'package:eirs/features/history/data/business_logic/device_history_bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../main.dart';
import '../../../theme/colors.dart';
import '../../component/button.dart';
import '../../component/eirs_app_bar.dart';
import '../../component/input_borders.dart';
import '../../component/localization_dialog.dart';
import '../../component/need_any_help_widget.dart';
import '../../history/presentation/device_history_screen.dart';
import '../../imei_result/presentation/imei_result_screen.dart';
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
  final TextEditingController imeiController = TextEditingController();
  String text = "0/15";
  Color textColor = AppColors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EirsAppBar(
        title: AppLocalizations.of(context)!.appName,
        callback: (value) {
          _appBarActions(value);
        },
      ),
      body: BlocConsumer<CheckImeiBloc, CheckImeiState>(
        builder: (context, state) {
          if (state is CheckImeiLoadingState || state is LanguageLoadingState) {
            return const CustomProgressIndicator(textColor: Colors.black);
          }
          return _imeiPageWidget();
        },
        listener: (context, state) {
          if (state is CheckImeiLoadedState) {
            _navigateResultScreen(state.checkImeiRes.result?.deviceDetails,
                state.checkImeiRes.result?.validImei ?? false);
          }

          if (state is CheckImeiErrorState) {
            _navigateResultScreen(null, false);
          }
        },
      ),
    );
  }

  void _navigateResultScreen(Map<String, dynamic>? data, bool isValidImei) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImeiResultScreen(
            title: StringConstants.result,
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
      return const ScannerPage();
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
              AppLocalizations.of(context)!.appName,
              style: TextStyle(fontSize: 20, color: AppColors.secondary),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 5),
              child: Text(AppLocalizations.of(context)!.enterImei,
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
                          decoration: const InputDecoration(
                              filled: true,
                              hintText: StringConstants.imeiNumberHint,
                              hintStyle: TextStyle(fontSize: 10),
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
                            style:
                                TextStyle(fontSize: 10, color: textColor),
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
                          AppLocalizations.of(context)!.or,
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
                          title: const Text(StringConstants.scanTitle),
                          description: const Text(StringConstants.scanDesc),
                          onOpen: () async {
                            return true;
                          },
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => _startScanner(),
                                child:
                                    SvgPicture.asset(ImageConstants.scanIcon),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  AppLocalizations.of(context)!.scanBarcode,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ],
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
                child: Text(AppLocalizations.of(context)!.checkImei),
                onPressed: () => _checkImei(context),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  AppLocalizations.of(context)!.findImei,
                  style: TextStyle(color: AppColors.secondary, fontSize: 14.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: Text(
                AppLocalizations.of(context)!.optionA,
                style: TextStyle(color: AppColors.buttonColor, fontSize: 14.0),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.optionALabel,
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
                  child: Image.asset(ImageConstants.deviceBox),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                AppLocalizations.of(context)!.or,
                style: TextStyle(fontSize: 14, color: AppColors.greyTextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                AppLocalizations.of(context)!.optionB,
                style: TextStyle(color: AppColors.buttonColor, fontSize: 14.0),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.optionBLabel,
              style: TextStyle(color: AppColors.black, fontSize: 14.0),
            ),
            Image.asset(ImageConstants.deviceInfo),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: NeedAnyHelpWidget(),
            )
          ],
        ),
      ),
    );
  }
}
