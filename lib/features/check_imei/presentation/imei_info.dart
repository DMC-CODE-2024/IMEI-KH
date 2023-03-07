import 'package:eirs/constants/image_path.dart';
import 'package:eirs/features/component/localization_dialog.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/strings.dart';
import '../../../helper/app_states.dart';
import '../../../helper/shared_pref.dart';
import '../../../main.dart';
import '../../../provider/app_locale.dart';
import '../../../theme/colors.dart';
import '../../component/button.dart';
import '../../component/eirs_app_bar.dart';
import '../../imei_result/presentation/imei_result_screen.dart';
import '../../scanner/scanner_screen.dart';
import '../data/business_logic/check_imei_bloc.dart';
import '../data/business_logic/check_imei_state.dart';

class ImeiInfoScreen extends StatefulWidget {
  const ImeiInfoScreen({super.key, required String title});

  @override
  State<ImeiInfoScreen> createState() => _ImeiInfoScreenState();
}

class _ImeiInfoScreenState extends State<ImeiInfoScreen> {
  late String currentDefaultSystemLocale;
  int selectedLangIndex = 0;
  var _appLocale;
  String _scanBarcode = '';

  //late CheckImeiBloc bloc;
  final TextEditingController imeiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //dropdownValue = AppLanguage.languages().first;
    print("Details is: ${AppStates.getLabelDetails()?.toJson()}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appLocale = Provider.of<AppLocale>(context);
    getLocale().then((locale) {
      _appLocale.changeLocale(Locale(locale.languageCode));
      // dropdownValue = AppLanguage.languages().firstWhere(
      //         (element) => element.languageCode == locale.languageCode);
      // _setFlag();
    });
  }

  void _setFlag() {
    currentDefaultSystemLocale = _appLocale.locale.languageCode.split('_')[0];
    setState(() {
      // selectedLangIndex = _getLangIndex(currentDefaultSystemLocale);
    });
  }

  int _getLangIndex(String currentDefaultSystemLocale) {
    int _langIndex = 0;
    switch (currentDefaultSystemLocale) {
      case 'en':
        _langIndex = 0;
        break;
      case 'km':
        _langIndex = 1;
        break;
    }
    return _langIndex;
  }

  @override
  Widget build(BuildContext context) {
    CheckImeiBloc bloc = BlocProvider.of<CheckImeiBloc>(context);
    bloc.add(CheckImeiInitEvent());
    return Scaffold(
      appBar: EirsAppBar(
        title: AppLocalizations.of(context)!.appName,
        callback: (value) {
          _appBarActions(value);
        },
      ),
      body: BlocConsumer<CheckImeiBloc, CheckImeiState>(
        builder: (context, state) {
          if (state is CheckImeiLoadedState) {
            return Container();
          }
          return _imeiPageWidget();
        },
        listener: (context, state) {
          if (state is CheckImeiLoadingState) {
            return;
          }
          if (state is CheckImeiLoadedState) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImeiResultScreen(
                    title: "Result",
                    scanImei: "",
                    data: state.checkImeiRes.result?.deviceDetails,
                    isValidImei:
                        state.checkImeiRes.result?.validImei ?? false)));
          }
        },
      ),
    );
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
                        child: TextField(
                          controller: imeiController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.grey)),
                              hintText: StringConstants.imeiNumberHint,
                              hintStyle: const TextStyle(fontSize: 10),
                              fillColor: Colors.white70),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            AppLocalizations.of(context)!.imeiNumberLength,
                            style:
                                TextStyle(fontSize: 10, color: AppColors.grey),
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
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => _startScanner(),
                              child: SvgPicture.asset(ImageConstants.scanIcon),
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
                  child: Image.asset(ImageConstants.deviceBox),
                  flex: 1,
                ),
                Flexible(
                  child: Image.asset(ImageConstants.deviceBox),
                  flex: 1,
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
            Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 5),
              child: Text(
                AppLocalizations.of(context)!.needAnyHelp,
                style:
                    TextStyle(color: AppColors.greyTextColor, fontSize: 14.0),
              ),
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.contactUs,
                  style: TextStyle(color: AppColors.black, fontSize: 14.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "xyz12@gmail.com",
                    style:
                        TextStyle(color: AppColors.secondary, fontSize: 14.0),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _startScanner() async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const ScannerPage();
    }));
  }

  void _showLocalizationDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return LocalizationDialog(callback: (value) {});
        });
  }

  void _checkImei(BuildContext context) {
    String inputImei = imeiController.text;
    //BlocProvider.of<CheckImeiBloc>(context).add(CheckImeiInitEvent(inputImei: inputImei));
    //Navigator.of(context).pushNamed(Routes.IMEI_RESULT);
  }

  void _appBarActions(AppBarActions values) {
    switch (values) {
      case AppBarActions.localization:
        _showLocalizationDialog();
        break;
      case AppBarActions.history:
        break;
      case AppBarActions.info:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FeatureDiscovery.discoverFeatures(
            context,
            const <String>{
              feature1,
              feature2,
              feature3,
              feature4,
              feature6,
              feature5
            },
          );
        });
        break;
    }
  }
}
