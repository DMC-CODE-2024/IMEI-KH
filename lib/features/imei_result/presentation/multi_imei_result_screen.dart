import 'package:eirs/features/check_multi_imei/data/models/multi_imei_res.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/constants.dart';
import '../../../constants/image_path.dart';
import '../../../constants/routes.dart';
import '../../../helper/shared_pref.dart';
import '../../../theme/colors.dart';
import '../../../theme/hex_color.dart';
import '../../check_imei/data/models/check_imei_res.dart';
import '../../check_multi_imei/data/business_logic/check_multi_imei_bloc.dart';
import '../../check_multi_imei/data/business_logic/check_multi_imei_event.dart';
import '../../check_multi_imei/data/business_logic/check_multi_imei_state.dart';
import '../../component/button.dart';
import '../../component/custom_progress_indicator.dart';
import '../../component/error_page.dart';
import '../../component/need_any_help_widget.dart';
import '../../component/result_app_bar.dart';
import '../../history/data/business_logic/device_history_bloc.dart';
import '../../history/presentation/device_history_screen.dart';

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

  @override
  void initState() {
    super.initState();
    getLocale().then((languageCode) {
      BlocProvider.of<CheckMultiImeiBloc>(context).add(CheckMultiImeiInitEvent(
          imeiMap: widget.imeiList,
          languageType: languageCode,
          requestCode: checkMultiImeiReq));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResultAppBar(
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
          }),
      body: BlocConsumer<CheckMultiImeiBloc, CheckMultiImeiState>(
        builder: (context, state) {
          if (state is CheckMultiImeiLoadingState) {
            return CustomProgressIndicator(
                labelDetails: widget.labelDetails, textColor: Colors.black);
          }
          if (state is CheckMultiImeiErrorState) {
            return Container(
              color: Colors.white,
              child: ErrorPage(
                  labelDetails: widget.labelDetails,
                  callback: (value) {
                    _reloadPage();
                  }),
            );
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
                              MultiImeiRes multiImeiRes = imeiResList![index];
                              if (multiImeiRes.checkImeiRes.result?.validImei ??
                                  false) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: validImeiList(
                                      multiImeiRes.checkImeiRes.result
                                              ?.deviceDetails ??
                                          {},
                                      multiImeiRes.imei,
                                      multiImeiRes.checkImeiRes.result),
                                );
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: invalidImeiList(multiImeiRes.imei,
                                      multiImeiRes.checkImeiRes.result),
                                );
                              }
                            }),
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 15),
                          child: AppButton(
                            isLoading: false,
                            child:
                                Text(widget.labelDetails?.checkOtherImei ?? ""),
                            onPressed: () {
                              widget.isSingleImeiReq
                                  ? Navigator.pop(context, isValidImei)
                                  : Navigator.pushNamedAndRemoveUntil(context,
                                      Routes.IMEI_SCREEN, (route) => false);
                            },
                          ),
                        ),
                        _emptyWidget(),
                        NeedAnyHelpWidget(
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
        },
      ),
    );
  }

  void _reloadPage() {
    BlocProvider.of<CheckMultiImeiBloc>(context)
        .add(CheckMultiImeiInitEvent(requestCode: pageRefresh));
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
        height: 60,
      );
    }
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
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SvgPicture.asset(ImageConstants.validIcon,
                      color: HexColor(statusColor ?? validStatusColor),
                      width: 70,
                      height: 70),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Html(
                      data: checkImeiResult?.complianceStatus ?? "",
                      shrinkWrap: true,
                      style: {'html': Style(textAlign: TextAlign.center)},
                    ),
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
                  Html(data: checkImeiResult?.message ?? "", style: {
                    'html': Style(textAlign: TextAlign.start),
                    'body':
                        Style(padding: HtmlPaddings.zero, margin: Margins.zero)
                  }),
                  Container(
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
                              padding: const EdgeInsets.symmetric(vertical: 18),
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
                                      padding: const EdgeInsets.only(right: 15),
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
                ],
              ),
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
              child: Html(
                data: checkImeiResult?.complianceStatus ?? "",
                shrinkWrap: true,
                style: {'html': Style(textAlign: TextAlign.center)},
              ),
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
                        Html(
                          data: checkImeiResult?.message ??
                              widget.labelDetails?.imeiNotPer3gpp ??
                              "",
                          shrinkWrap: true,
                          style: {'html': Style(textAlign: TextAlign.left)},
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
