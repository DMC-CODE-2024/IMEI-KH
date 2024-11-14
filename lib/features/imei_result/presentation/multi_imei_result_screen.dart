import 'package:eirs/constants/enums.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../constants/constants.dart';
import '../../../constants/image_path.dart';
import '../../../constants/routes.dart';
import '../../../helper/shared_pref.dart';
import '../../../theme/colors.dart';
import '../../../theme/hex_color.dart';
import '../../check_imei/data/models/check_imei_res.dart';
import '../../component/about_app_info_dialog.dart';
import '../../component/app_bar_with_icon_only.dart';
import '../../component/button.dart';
import '../../component/check_ip_error_page.dart';
import '../../component/custom_progress_indicator.dart';
import '../../component/error_page.dart';
import '../../component/need_any_help_widget.dart';
import '../../component/result_app_bar.dart';
import '../../history/data/business_logic/device_history_bloc.dart';
import '../../history/presentation/device_history_screen.dart';
import '../business_logic/check_multi_imei_bloc.dart';
import '../business_logic/check_multi_imei_state.dart';
import '../data/models/multi_imei_res.dart';

class MultiImeiResultScreen extends StatefulWidget {
  const MultiImeiResultScreen(
      {super.key,
      required this.isSingleImeiReq,
      required this.imeiList,
      required this.labelDetails});

  final bool isSingleImeiReq;
  final List<String>? imeiList;
  final LabelDetails? labelDetails;

  @override
  State<MultiImeiResultScreen> createState() => _MultiImeiResultScreenState();
}

class _MultiImeiResultScreenState extends State<MultiImeiResultScreen> {
  List<MultiImeiRes>? imeiResList;
  bool isValidImei = false;
  bool allowBackPress = true;

  @override
  void initState() {
    super.initState();
    //commented for testing
    //BlocProvider.of<CheckMultiImeiBloc>(context).checkCountryIpReq();
    //call multi check imei api
    navigateToCheckMultiImei();
  }

  _showAboutAppInfoDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return AboutAppInfoDialog(
            labelDetails: widget.labelDetails,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: allowBackPress
          ? ResultAppBar(
              title: widget.labelDetails?.result ?? "",
              callback: (value) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: DeviceHistoryBloc(),
                      child: const DeviceHistoryScreen(),
                    ),
                  ),
                );
              })
          : appBarWithIconOnly(_showAboutAppInfoDialog),
      body: PopScope(
          canPop: allowBackPress,
          child: BlocConsumer<CheckMultiImeiBloc, CheckMultiImeiState>(
            builder: (context, state) {
              if (state is CheckMultiImeiLoadingState ||
                  state is MultiImeiIpLoadingState) {
                return CustomProgressIndicator(
                    labelDetails: widget.labelDetails, textColor: Colors.black);
              }
              if (state is CheckMultiImeiErrorState ||
                  state is MultiImeiIpErrorState) {
                return Container(
                  color: Colors.white,
                  child: ErrorPage(
                      labelDetails: widget.labelDetails,
                      callback: (value) {
                        //_reloadPage();
                        navigateToHome();
                      }),
                );
              }
              if (state is MultiImeiIpLoadedState) {
                if (state.checkCountryIPRes.countryCode != "KH") {
                  return CheckIpErrorPage(
                      labelDetails: widget.labelDetails,
                      callback: (value) {
                        navigateToHome();
                      });
                }
              }

              return (imeiResList != null && imeiResList!.isNotEmpty)
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            widget.labelDetails?.imeiInfo ?? "",
                            style: TextStyle(
                                fontSize: 20.0, color: AppColors.secondary),
                          ),
                        ),*/
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: imeiResList?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  MultiImeiRes multiImeiRes =
                                      imeiResList![index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: (imeiResList?.length == 1)
                                        ? displaySingleImeiResult(
                                            multiImeiRes.checkImeiRes.result
                                                    ?.deviceDetails ??
                                                {},
                                            multiImeiRes.imei,
                                            multiImeiRes.checkImeiRes.result)
                                        : displayCheckImeiResult(
                                            multiImeiRes.checkImeiRes.result
                                                    ?.deviceDetails ??
                                                {},
                                            multiImeiRes.imei,
                                            multiImeiRes.checkImeiRes.result),
                                  );
                                  /* if (multiImeiRes.checkImeiRes.result?.statusColor == StatusColor.red.value) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: invalidImeiList(multiImeiRes.imei,
                                          multiImeiRes.checkImeiRes.result),
                                    );
                                  }
                                  else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: validImeiList(
                                          multiImeiRes.checkImeiRes.result
                                                  ?.deviceDetails ??
                                              {},
                                          multiImeiRes.imei,
                                          multiImeiRes.checkImeiRes.result),
                                    );
                                  }*/
                                }),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: AppButton(
                                isLoading: false,
                                child: Text(
                                    widget.labelDetails?.checkOtherImei ?? ""),
                                onPressed: () => navigateToHome(),
                              ),
                            ),
                            (imeiResList?.length == 1)
                                ? Container()
                                : _emptyWidget(),
                            (imeiResList?.length == 1)
                                ? Container()
                                : NeedAnyHelpWidget(
                                    labelDetails: widget.labelDetails,
                                  )
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
            listener: (context, state) {
              if (state is CheckMultiImeiLoadedState) {
                setState(() {
                  isValidImei = state.isValidImei;
                  imeiResList = state.multiImeiResList;
                });
              }

              if (state is MultiImeiIpLoadedState) {
                if (state.checkCountryIPRes.countryCode != "KH") {
                  setState(() {
                    allowBackPress = false;
                  });
                } else {
                  navigateToCheckMultiImei();
                }
              }
            },
          )),
    );
  }

  void navigateToCheckMultiImei() {
    getLocale().then((languageCode) {
      BlocProvider.of<CheckMultiImeiBloc>(context)
          .checkMultiIMEIReq(languageCode, widget.imeiList);
    });
  }

  void navigateToHome() {
    widget.isSingleImeiReq
        ? Navigator.pop(context, isValidImei)
        : Navigator.pushNamedAndRemoveUntil(
            context, Routes.IMEI_SCREEN, (route) => false);
  }

  Widget _emptyWidget() {
    if (imeiResList?.length == 1) {
      bool isValidImei =
          imeiResList?.first.checkImeiRes.result?.validImei ?? false;
      return Container(
        height: (isValidImei) ? 125 : 180,
      );
    } else {
      return Container(
        height: 180,
      );
    }
  }

  Widget displaySingleImeiResult(Map<String, dynamic> data, String imei,
      CheckImeiResult? checkImeiResult) {
    var statusColor = checkImeiResult?.statusColor;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: (statusColor == StatusColor.darYellow.value)
                    ? Image.asset(ImageConstants.warning,
                        fit: BoxFit.contain, width: 70, height: 70)
                    : SvgPicture.asset(
                        (statusColor == StatusColor.red.value)
                            ? ImageConstants.invalidIcon
                            : ImageConstants.validIcon,
                        color: HexColor(statusColor ?? validStatusColor),
                        width: 70,
                        height: 70),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: HtmlWidget(checkImeiResult?.complianceStatus ?? ""),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 4),
                child: Row(
                  children: [
                    Text(
                      widget.labelDetails?.imei ?? "",
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        imei,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
              (data.entries.isNotEmpty)
                  ? SizedBox(
                      height: 60,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: HtmlWidget(checkImeiResult?.message ?? ""),
                        ),
                      ),
                    )
                  : HtmlWidget(checkImeiResult?.message ?? ""),
              (data.entries.isNotEmpty)
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Table(
                        border: TableBorder(
                          horizontalInside: BorderSide(
                              width: 1,
                              color: AppColors.borderColor,
                              style: BorderStyle.solid),
                        ),
                        children: data.entries.map((deviceDetailMap) {
                          return TableRow(children: [
                            TableCell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(deviceDetailMap.key),
                                    )),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Text(deviceDetailMap.value),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]);
                        }).toList(),
                      ),
                    )
                  : Container()
            ],
          ),
        ],
      ),
    );
  }

  Widget displayCheckImeiResult(Map<String, dynamic> data, String imei,
      CheckImeiResult? checkImeiResult) {
    var statusColor = checkImeiResult?.statusColor;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: (statusColor == StatusColor.darYellow.value)
                      ? Image.asset(ImageConstants.warning,
                          fit: BoxFit.contain, width: 70, height: 70)
                      : SvgPicture.asset(
                          (statusColor == StatusColor.red.value)
                              ? ImageConstants.invalidIcon
                              : ImageConstants.validIcon,
                          color: HexColor(statusColor ?? validStatusColor),
                          width: 70,
                          height: 70),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: HtmlWidget(checkImeiResult?.complianceStatus ?? ""),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        widget.labelDetails?.imei ?? "",
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          imei,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                HtmlWidget(checkImeiResult?.message ?? ""),
                (data.entries.isNotEmpty)
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Table(
                          border: TableBorder(
                            horizontalInside: BorderSide(
                                width: 1,
                                color: AppColors.borderColor,
                                style: BorderStyle.solid),
                          ),
                          children: data.entries.map((deviceDetailMap) {
                            return TableRow(children: [
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(deviceDetailMap.key),
                                      )),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Text(deviceDetailMap.value),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]);
                          }).toList(),
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget validImeiList(Map<String, dynamic> data, String imei,
      CheckImeiResult? checkImeiResult) {
    var statusColor = checkImeiResult?.statusColor;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: (statusColor == StatusColor.darYellow.value)
                      ? Image.asset(ImageConstants.warning,
                          fit: BoxFit.contain, width: 70, height: 70)
                      : SvgPicture.asset(ImageConstants.validIcon,
                          color: HexColor(statusColor ?? validStatusColor),
                          width: 70,
                          height: 70),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: HtmlWidget(checkImeiResult?.complianceStatus ?? ""),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        widget.labelDetails?.imei ?? "",
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          imei,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                HtmlWidget(checkImeiResult?.message ?? ""),
                (data.entries.isNotEmpty)
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Table(
                          border: TableBorder(
                            horizontalInside: BorderSide(
                                width: 1,
                                color: AppColors.borderColor,
                                style: BorderStyle.solid),
                          ),
                          children: data.entries.map((deviceDetailMap) {
                            return TableRow(children: [
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(deviceDetailMap.key),
                                      )),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Text(deviceDetailMap.value),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]);
                          }).toList(),
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget invalidImeiList(String imei, CheckImeiResult? checkImeiResult) {
    var statusColor = checkImeiResult?.statusColor;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageConstants.invalidIcon,
              color: HexColor(statusColor ?? invalidStatusColor),
              width: 70,
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Center(
                  child: HtmlWidget(checkImeiResult?.complianceStatus ?? "")),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: Row(
                children: [
                  Text(
                    widget.labelDetails?.imei ?? "",
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      imei,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 5.0, right: 10),
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 20, left: 15, right: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.errorBorderColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0) //
                              ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*Text(
                          widget.labelDetails?.remark ?? "",
                          style:
                              TextStyle(fontSize: 14.0, color: AppColors.black),
                        ),*/
                        HtmlWidget(
                          checkImeiResult?.message ??
                              widget.labelDetails?.imeiNotPer3gpp ??
                              "",
                        )
                      ],
                    ),
                  ),
                  /*       Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 20.0, bottom: 20.0, right: 40),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(18.0) //
                              ),
                    ),
                    child: Text(
                      widget.labelDetails?.callToAction ?? "",
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                  )*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
