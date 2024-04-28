import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eirs/features/check_imei/data/business_logic/home_imei_bloc.dart';
import 'package:eirs/features/check_imei/drawer_menu/menu_model.dart';
import 'package:eirs/features/check_imei/drawer_menu/sub_menu_model.dart';
import 'package:eirs/features/check_imei/drawer_menu/web_page.dart';
import 'package:eirs/features/component/about_app_info_dialog.dart';
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

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../helper/shared_pref.dart';
import '../../../main.dart';
import '../../../theme/colors.dart';
import '../../component/app_bar_with_icon_only.dart';
import '../../component/button_opacity.dart';
import '../../component/eirs_app_bar.dart';
import '../../component/error_page.dart';
import '../../component/input_borders.dart';
import '../../component/need_any_help_widget.dart';
import '../../component/no_internet_page.dart';
import '../../history/presentation/device_history_screen.dart';
import '../../imei_result/business_logic/check_multi_imei_bloc.dart';
import '../../imei_result/presentation/multi_imei_result_screen.dart';
import '../../launcher/data/models/device_details_res.dart';
import '../../scanner/data/business_logic/scanner_bloc.dart';
import '../../scanner/scanner_screen.dart';
import '../data/business_logic/check_imei_state.dart';
import '../drawer_menu/menu_widget.dart';

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
  int inputTextLength = 0;
  String versionName = "";
  String emptyString = "";
  Color textColor = AppColors.grey;
  LabelDetails? labelDetails;
  bool reloadPage = false;
  bool isEnglish = true;
  bool isCoachScreenVisible = false;
  int selected = -1;

  // You need to save an instance of a GlobalKey in order to call ensureVisible in onOpen.
  GlobalKey<EnsureVisibleState> ensureVisibleGlobalKey =
      GlobalKey<EnsureVisibleState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    });
    PackageInfo.fromPlatform().then((value) {
      versionName = value.version;
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
    BlocProvider.of<HomeImeiBloc>(context).pageRefresh();
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
                    callback: (action, isEnglishLanguageSelected) {
                      _appBarActions(action, isEnglishLanguageSelected);
                    },
                    dismissCallback: () => _updateCoachScreenStatus(false),
                  )
                : appBarWithIconOnly(_showAboutAppInfoDialog),
            body: Scaffold(
              key: _scaffoldKey,
              endDrawer: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Drawer(
                  child: expendableList(
                      labelDetails?.menuList ??
                          (isEnglish ? menuItem() : khmerMenuItem()), selected,_menuChildItemCallback),
                ),
              ),
              body: PopScope(
                canPop: !isCoachScreenVisible,
                onPopInvoked: (didInvoke) {
                  if (!didInvoke) _onBackPressHandle();
                },
                child: BlocConsumer<HomeImeiBloc, CheckImeiState>(
                  builder: (context, state) {
                    if (!hasNetwork) {
                      return NoInternetPage(
                          labelDetails: labelDetails,
                          callback: (value) {
                            _reloadPage();
                          });
                    }
                    if (state is LanguageLoadingState) {
                      return CustomProgressIndicator(
                          labelDetails: labelDetails, textColor: Colors.black);
                    }

                    if (state is LanguageErrorState) {
                      return ErrorPage(
                          labelDetails: labelDetails,
                          callback: (value) {
                            _reloadPage();
                          });
                    }
                    return _imeiPageWidget();
                  },
                  listener: (context, state) {
                    if (state is LanguageLoadedState) {
                      selectedLng = state.deviceDetailsRes.languageType ??
                          StringConstants.englishCode;
                      switch (selectedLng) {
                        case StringConstants.englishCode:
                          isEnglish = true;
                          break;
                        case StringConstants.khmerCode:
                          isEnglish = false;
                          break;
                      }
                      Provider.of<AppStatesNotifier>(context, listen: false)
                          .updateLanguageState(isEnglish);
                      Provider.of<AppStatesNotifier>(context, listen: false)
                          .updateState(state.deviceDetailsRes.labelDetails);
                    }
                  },
                ),
              ),
            ),
          );
        });
  }

  _menuChildItemCallback(String title, String? clickUrl) {
    if (clickUrl != null && clickUrl.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WebPage(title: title, url: clickUrl)));
    }
  }

  _onBackPressHandle() async {
    _updateCoachScreenStatus(false);
    if (!mounted) return;
    FeatureDiscovery.dismissAll(context);
  }

  List<MenuModel> menuItem() {
    SubMenuModel report = SubMenuModel();
    report.title = "Report Lost/ Stolen Device";
    report.url = "https://lab1.goldilocks-tech.com/LOSTSTOLEN/requestStolenRecovery?type=0&lang=en";

    SubMenuModel report2 = SubMenuModel();
    report2.title = "Check Status of Request";
    report2.url =
        "https://lab1.goldilocks-tech.com/LOSTSTOLEN/requestStolenRecovery?type=2&lang=en";

    SubMenuModel report3 = SubMenuModel();
    report3.title = "Unblock Lost/Stolen Device";
    report3.url =
        "https://lab1.goldilocks-tech.com/LOSTSTOLEN/requestStolenRecovery?type=1&lang=en#!";

    MenuModel menuModel = MenuModel();
    menuModel.title = "Lost/Stolen";
    menuModel.icon = ImageConstants.lostStolen;
    menuModel.childList = [report, report2, report3];

    SubMenuModel subMenuModel = SubMenuModel();
    subMenuModel.title = "Pair Device";
    subMenuModel.url = "https://lab1.goldilocks-tech.com/EIRSCoreSystem/pair-device?lang=en";

    SubMenuModel subMenuModel2 = SubMenuModel();
    subMenuModel2.title = "Re-Pair Device";
    subMenuModel2.url = "https://lab1.goldilocks-tech.com/EIRSCoreSystem/repair-device?lang=en";

    SubMenuModel subMenuModel3 = SubMenuModel();
    subMenuModel3.title = "Check pair status";
    subMenuModel3.url = "https://lab1.goldilocks-tech.com/EIRSCoreSystem/check-pair-status?lang=en";

    MenuModel menuModel2 = MenuModel();
    menuModel2.title = "Pairing";
    menuModel2.icon = ImageConstants.pairing;;
    menuModel2.childList = [subMenuModel, subMenuModel2, subMenuModel3];

    SubMenuModel ticket = SubMenuModel();
    ticket.title = "Raise New Ticket";
    ticket.url = "https://lab1.goldilocks-tech.com/eirs/register-ticket?lang=en&header=no";

    SubMenuModel ticket2 = SubMenuModel();
    ticket2.title = "Check Ticket Status";
    ticket2.url = "https://lab1.goldilocks-tech.com/eirs/view-ticket?lang=en&header=no";

    MenuModel menuModel3 = MenuModel();
    menuModel3.title = "Ticket";
    menuModel3.icon = ImageConstants.ticket;
    menuModel3.childList = [ticket,ticket2];

    return [
      menuModel,
      menuModel2,
      menuModel3
    ];
  }

  List<MenuModel> khmerMenuItem() {
    SubMenuModel report = SubMenuModel();
    report.title = "រាយការណ៍ឧបករណ៍ដែលបាត់/លួច";
    report.url = "https://lab1.goldilocks-tech.com/LOSTSTOLEN/requestStolenRecovery?type=0&lang=km";

    SubMenuModel report2 = SubMenuModel();
    report2.title = "ពិនិត្យស្ថានភាពនៃការស្នើសុំ";
    report2.url = "https://lab1.goldilocks-tech.com/LOSTSTOLEN/requestStolenRecovery?type=2&lang=km";

    SubMenuModel report3 = SubMenuModel();
    report3.title = "ដោះសោឧបករណ៍ដែលបាត់/លួច";
    report3.url = "https://lab1.goldilocks-tech.com/LOSTSTOLEN/requestStolenRecovery?type=1&lang=km#!";

    MenuModel menuModel = MenuModel();
    menuModel.title = "បាត់/លួច";
    menuModel.icon = ImageConstants.lostStolen;
    menuModel.childList = [report, report2, report3];

    SubMenuModel subMenuModel = SubMenuModel();
    subMenuModel.title = "ផ្គូផ្គងឧបករណ៍";
    subMenuModel.url = "https://lab1.goldilocks-tech.com/EIRSCoreSystem/pair-device?lang=km";

    SubMenuModel subMenuModel2 = SubMenuModel();
    subMenuModel2.title = "ផ្គូផ្គងឧបករណ៍ឡើងវិញ";
    subMenuModel2.url = "https://lab1.goldilocks-tech.com/EIRSCoreSystem/repair-device?lang=km";

    SubMenuModel subMenuModel3 = SubMenuModel();
    subMenuModel3.title = "ពិនិត្យស្ថានភាពគូ";
    subMenuModel3.url = "https://lab1.goldilocks-tech.com/EIRSCoreSystem/check-pair-status?lang=km";

    MenuModel menuModel2 = MenuModel();
    menuModel2.title = "ផ្គូផ្គងឧបករណ៍";
    menuModel2.icon = ImageConstants.pairing;
    menuModel2.childList = [subMenuModel, subMenuModel2, subMenuModel3];

    SubMenuModel ticket = SubMenuModel();
    ticket.title = "ដំឡើងសំបុត្រថ្មី។";
    ticket.url = "https://lab1.goldilocks-tech.com/eirs/register-ticket?lang=km&header=no";

    SubMenuModel ticket2 = SubMenuModel();
    ticket2.title = "ពិនិត្យស្ថានភាពសំបុត្រ";
    ticket2.url = "https://lab1.goldilocks-tech.com/eirs/view-ticket?lang=km&header=no";

    MenuModel menuModel3 = MenuModel();
    menuModel3.title = "សំបុត្រ";
    menuModel3.icon = ImageConstants.ticket;
    menuModel3.childList = [ticket,ticket2];

    return [menuModel, menuModel2, menuModel3];
  }

  void _appBarActions(AppBarActions values, bool isEnglishLanguageSelected) {
    switch (values) {
      case AppBarActions.menu:
        setState(() {
          selected = -1;
        });
        _scaffoldKey.currentState?.openEndDrawer();
        break;
      case AppBarActions.appLogo:
        _showAboutAppInfoDialog();
        break;
      case AppBarActions.localization:
        _showLocalizationDialog(isEnglishLanguageSelected);
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
        _updateCoachScreenStatus(true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FeatureDiscovery.discoverFeatures(
            context,
            const <String>{feature1, feature2, feature3, feature4, feature5},
          );
        });
        break;
    }
  }

  _updateCoachScreenStatus(bool status) {
    setState(() {
      isCoachScreenVisible = status;
    });
  }

  _showAboutAppInfoDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return AboutAppInfoDialog(
            labelDetails: labelDetails,
          );
        });
  }

  void _showLocalizationDialog(bool isEnglishLanguageSelected) {
    if (hasNetwork) {
      BlocProvider.of<HomeImeiBloc>(context).changeLanguageReq(
          isEnglishLanguageSelected
              ? StringConstants.khmerCode
              : StringConstants.englishCode);
    }
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
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: CheckMultiImeiBloc(),
          child: MultiImeiResultScreen(
              isSingleImeiReq: true,
              imeiList: [inputImei],
              labelDetails: labelDetails),
        ),
      ),
    )
        .then((value) {
      if (value == true) {
        setState(() {
          imeiController.clear();
          text = "0/15";
          inputTextLength = 0;
          textColor = AppColors.grey;
        });
      }
    });
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
    await Navigator.push(
        context,
        MaterialPageRoute(
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
                              if (value.length == 15) {
                                textColor = Colors.green;
                              } else {
                                textColor = Colors.grey;
                              }
                              inputTextLength = value.length;
                              text = "${value.length}/15";
                            })
                          },
                          enableInteractiveSelection: true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          cursorHeight: 18,
                          style: const TextStyle(fontSize: 14),
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
                              enabledBorder: (textColor == Colors.green)
                                  ? InputBorders.focused
                                  : InputBorders.enabled,
                              errorBorder: InputBorders.error,
                              focusedErrorBorder: InputBorders.error,
                              border: InputBorders.border,
                              focusedBorder: (textColor == Colors.green)
                                  ? InputBorders.focused
                                  : InputBorders.border),
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
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        labelDetails?.or ?? emptyString,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
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
                          WidgetsBinding.instance
                              .addPostFrameCallback((Duration duration) {
                            ensureVisibleGlobalKey.currentState
                                ?.ensureVisible();
                          });
                          return true;
                        },
                        onComplete: () async {
                          _updateCoachScreenStatus(false);
                          return true;
                        },
                        onDismiss: () async {
                          _updateCoachScreenStatus(false);
                          return true;
                        },
                        child: GestureDetector(
                          onTap: () => _startScanner(),
                          child: Column(
                            children: [
                              EnsureVisible(
                                  key: ensureVisibleGlobalKey,
                                  child: SvgPicture.asset(
                                      ImageConstants.scanIcon)),
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
              child: AppButtonOpacity(
                isLoading: false,
                isEnable: (inputTextLength > 0) ? true : false,
                child: Text(labelDetails?.checkIMEI ?? emptyString,
                    textAlign: TextAlign.center),
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
              labelDetails?.dial ?? emptyString,
              style: TextStyle(color: AppColors.black, fontSize: 14.0),
            ),
            Image.asset(ImageConstants.deviceInfo),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                labelDetails?.optionB ?? emptyString,
                style: TextStyle(color: AppColors.buttonColor, fontSize: 14.0),
              ),
            ),
            Text(
              labelDetails?.imeiAlsoWrittenInBox ?? emptyString,
              style: TextStyle(color: AppColors.black, fontSize: 14.0),
            ),
            Image.asset(ImageConstants.optionA),
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
