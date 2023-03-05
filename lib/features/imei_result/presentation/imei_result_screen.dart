import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/component/result_app_bar.dart';
import 'package:eirs/features/imei_result/data/models/device_details.dart';
import 'package:eirs/features/imei_result/presentation/widget/device_details_list.dart';
import 'package:eirs/features/imei_result/presentation/widget/invalid_imei.dart';
import 'package:eirs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/image_path.dart';
import '../../component/button.dart';
import '../../component/need_any_help_widget.dart';

class ImeiResultScreen extends StatefulWidget {
  const ImeiResultScreen(
      {super.key,
      required this.title,
      required this.scanImei,
      required this.data,
      required this.isValidImei});

  final String title;
  final String scanImei;
  final Map<String, dynamic>? data;
  final bool isValidImei;

  @override
  State<ImeiResultScreen> createState() => _ImeiResultScreenState();
}

class _ImeiResultScreenState extends State<ImeiResultScreen> {
  List<DeviceDetails> deviceList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            ResultAppBar(title: StringConstants.result, callback: (value) {}),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Text(
                        StringConstants.imeiInfo,
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
                            SvgPicture.asset((widget.isValidImei == true)
                                ? ImageConstants.imeiValidIcon
                                : ImageConstants.imeiInValidIcon),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                (widget.isValidImei == true)
                                    ? "Valid"
                                    : "InValid",
                                style: const TextStyle(fontSize: 24.0),
                              ),
                            )
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
                    if (widget.isValidImei && widget.data != null)
                      DeviceDetailList(data: widget.data!)
                    else
                      const InvalidImeiResult(),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: AppButton(
                        isLoading: false,
                        child: const Text(StringConstants.checkOtherImei),
                        onPressed: () => {Navigator.of(context).pop()},
                      ),
                    )
                  ],
                )),
                const NeedAnyHelpWidget()
              ],
            )));
  }
}
