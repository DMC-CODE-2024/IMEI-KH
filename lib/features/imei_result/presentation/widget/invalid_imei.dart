import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../theme/colors.dart';
import '../../../launcher/data/models/device_details_res.dart';

class InvalidImeiResult extends StatelessWidget {
  const InvalidImeiResult({Key? key, this.labelDetails, this.errorMsg})
      : super(key: key);

  final LabelDetails? labelDetails;
  final String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8.0,bottom: 8,right: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.errorBorderColor),
            borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Text(
                labelDetails?.remark ?? "",
                style: TextStyle(fontSize: 14.0, color: AppColors.black),
              ),*/
              Html(
                data: errorMsg ?? labelDetails?.imeiNotPer3gpp ?? "",
                shrinkWrap: true,
                style: {'html': Style(textAlign: TextAlign.left)},
              ),
            ],
          ),
        ),
        /*  Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(20.0) //
                ),
          ),
          child: Text(
            labelDetails?.callToAction ?? "",
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        )*/
      ],
    );
  }
}
