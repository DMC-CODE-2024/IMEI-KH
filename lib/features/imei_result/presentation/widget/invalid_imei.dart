import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../launcher/data/models/device_details_res.dart';

class InvalidImeiResult extends StatelessWidget {
  const InvalidImeiResult({
    Key? key,
    this.labelDetails,
  }) : super(key: key);

  final LabelDetails? labelDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelDetails?.remark ?? "",
                style: TextStyle(fontSize: 14.0, color: AppColors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  labelDetails?.imeiNotPer3gpp ?? "",
                  style: TextStyle(fontSize: 14.0, color: AppColors.black),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(15.0) //
                ),
          ),
          child: Text(
            labelDetails?.callToAction ?? "",
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        )
      ],
    );
  }
}
