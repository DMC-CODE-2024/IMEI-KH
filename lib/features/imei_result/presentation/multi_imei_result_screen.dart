import 'package:eirs/features/check_imei/presentation/check_imei_screen.dart';
import 'package:eirs/features/check_multi_imei/data/models/multi_imei_res.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/image_path.dart';
import '../../../constants/routes.dart';
import '../../../constants/strings.dart';
import '../../../theme/colors.dart';
import '../../component/button.dart';
import '../../component/need_any_help_widget.dart';
import '../../component/result_app_bar.dart';
import '../../history/data/business_logic/device_history_bloc.dart';
import '../../history/presentation/device_history_screen.dart';

class MultiImeiResultScreen extends StatefulWidget {
  const MultiImeiResultScreen(
      {super.key, required this.imeiResList, required this.labelDetails});

  final List<MultiImeiRes>? imeiResList;
  final LabelDetails? labelDetails;

  @override
  State<MultiImeiResultScreen> createState() => _MultiImeiResultScreenState();
}

class _MultiImeiResultScreenState extends State<MultiImeiResultScreen> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Text(
                  widget.labelDetails?.imeiInfo ?? "",
                  style: TextStyle(fontSize: 20.0, color: AppColors.secondary),
                ),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.imeiResList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    MultiImeiRes multiImeiRes = widget.imeiResList![index];
                    if (multiImeiRes.checkImeiRes.result?.validImei ?? false) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: validImeiList(
                            multiImeiRes.checkImeiRes.result?.deviceDetails ??
                                {},
                            multiImeiRes.imei),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: invalidImeiList(
                          multiImeiRes.imei,
                        ),
                      );
                    }
                  }),
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                child: AppButton(
                  isLoading: false,
                  child: Text(widget.labelDetails?.checkOtherImei ?? ""),
                  onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.IMEI_SCREEN, (route) => false)
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
      ),
    );
  }

  Widget _emptyWidget() {
    if (widget.imeiResList?.length == 1) {
      bool isValidImei =
          widget.imeiResList?.first.checkImeiRes.result?.validImei ?? false;
      return Container(
        height: (isValidImei) ? 125 : 180,
      );
    } else {
      return Container(
        height: 60,
      );
    }
  }

  Widget validImeiList(Map<String, dynamic> data, String imei) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.validBg,
        borderRadius: const BorderRadius.all(
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
                  SvgPicture.asset(ImageConstants.imeiValidIcon),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                    child: Text(
                      widget.labelDetails?.valid ?? "",
                      style:
                          const TextStyle(fontSize: 24.0, color: Colors.green),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 15),
                    child: Row(
                      children: [
                        const Text(
                          StringConstants.imei,
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            imei,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.green,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(
                            width: 1,
                            color: Colors.green,
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

  Widget invalidImeiList(String imei) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inVlidBg,
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ImageConstants.imeiInValidIcon),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                widget.labelDetails?.invalid ?? "",
                style: const TextStyle(fontSize: 24.0, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: Row(
                children: [
                  const Text(
                    StringConstants.imei,
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
                    margin: const EdgeInsets.only(bottom: 5.0, right: 40),
                    padding: const EdgeInsets.only(
                        top: 30.0, bottom: 30, left: 15, right: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0) //
                              ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.labelDetails?.remark ?? "",
                          style:
                              TextStyle(fontSize: 14.0, color: AppColors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            widget.labelDetails?.imeiNotPer3gpp ?? "",
                            style: TextStyle(
                                fontSize: 14.0, color: AppColors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}