import 'package:eirs/constants/constants.dart';
import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/check_imei/data/models/check_imei_res.dart';
import 'package:eirs/features/component/result_app_bar.dart';
import 'package:eirs/features/imei_result/data/models/device_details.dart';
import 'package:eirs/features/imei_result/presentation/widget/device_details_list.dart';
import 'package:eirs/features/imei_result/presentation/widget/invalid_imei.dart';
import 'package:eirs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/image_path.dart';
import '../../../theme/hex_color.dart';
import '../../component/button.dart';
import '../../component/need_any_help_widget.dart';
import '../../history/data/business_logic/device_history_bloc.dart';
import '../../history/presentation/device_history_screen.dart';
import '../../launcher/data/models/device_details_res.dart';

class ImeiResultScreen extends StatefulWidget {
  const ImeiResultScreen(
      {super.key,
      required this.labelDetails,
      required this.scanImei,
      required this.checkImeiResult});

  final LabelDetails? labelDetails;
  final String scanImei;
  final CheckImeiResult checkImeiResult;

  @override
  State<ImeiResultScreen> createState() => _ImeiResultScreenState();
}

class _ImeiResultScreenState extends State<ImeiResultScreen> {
  List<DeviceDetails> deviceList = [];
  String emptyString = "";

  @override
  Widget build(BuildContext context) {
    var statusColor = widget.checkImeiResult.statusColor;
    var isValidImei = widget.checkImeiResult.validImei;
    return Scaffold(
      appBar: ResultAppBar(
        title: widget.labelDetails?.result ?? emptyString,
        callback: (value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: DeviceHistoryBloc(),
                child: const DeviceHistoryScreen(),
              ),
            ),
          );
        },
        backButtonCallBack: () {
          Navigator.pop(context, isValidImei);
        },
      ),
      body: WillPopScope(
        onWillPop: () {
          //on Back button press, you can use WillPopScope for another purpose also.
          Navigator.pop(context, isValidImei); //return data along with pop
          return Future(
              () => false); //onWillPop is Future<bool> so return false
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Text(
                        widget.labelDetails?.imeiInfo ?? emptyString,
                        style: TextStyle(
                            fontSize: 20.0, color: AppColors.secondary),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              (isValidImei)
                                  ? ImageConstants.validIcon
                                  : ImageConstants.invalidIcon,
                              color: HexColor((statusColor != null)
                                  ? statusColor
                                  : (isValidImei)
                                      ? validStatusColor
                                      : invalidStatusColor),
                            ),
                            Padding(
                              padding: (isValidImei)
                                  ? const EdgeInsets.only(
                                      top: 10.0, bottom: 8.0)
                                  : const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                widget.checkImeiResult.complianceStatus ?? emptyString,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black),
                              ),
                            ),
                            (isValidImei)
                                ? Text(
                                    widget.checkImeiResult.message ??
                                        emptyString,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          StringConstants.imei,
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            widget.scanImei,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    if (isValidImei &&
                        widget.checkImeiResult.deviceDetails != null)
                      DeviceDetailList(
                          data: widget.checkImeiResult.deviceDetails!)
                    else
                      InvalidImeiResult(
                        labelDetails: widget.labelDetails,
                        errorMsg: widget.checkImeiResult.message,
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: AppButton(
                        isLoading: false,
                        child: Text(
                            widget.labelDetails?.checkOtherImei ?? emptyString),
                        onPressed: () => {Navigator.pop(context, isValidImei)},
                      ),
                    ),
                  ],
                ),
                _emptyWidget(),
                NeedAnyHelpWidget(
                  labelDetails: widget.labelDetails,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyWidget() {
    if (widget.checkImeiResult.validImei) {
      return Container(
        height: 125,
      );
    } else {
      return Container(
        height: 245,
      );
    }
  }
}
