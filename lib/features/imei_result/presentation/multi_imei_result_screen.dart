import 'package:eirs/features/check_multi_imei/data/models/multi_imei_res.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:flutter/material.dart';

import '../../../constants/strings.dart';
import '../../../theme/colors.dart';

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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.imeiResList?.length,
        itemBuilder: (BuildContext context, int index) {
          MultiImeiRes multiImeiRes = widget.imeiResList![index];
          if (multiImeiRes.checkImeiRes.result?.validImei ?? false) {
            return validImeiList(
                multiImeiRes.checkImeiRes.result?.deviceDetails,
                multiImeiRes.imei);
          } else {
            return invalidImeiList();
          }
        });
  }

  Widget validImeiList(Map<String, dynamic>? values, String imei) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: values?.length,
      itemBuilder: (BuildContext context, int index) {
        String key = values?.keys.elementAt(index) ?? "";
        return InkWell(
          onTap: () => {},
          child: ListTile(
            title: Text("${StringConstants.imei} ${index + 1}"),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: Text(key),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget invalidImeiList() {
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
                widget.labelDetails?.remark ?? "",
                style: TextStyle(fontSize: 14.0, color: AppColors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  widget.labelDetails?.imeiNotPer3gpp ?? "",
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
            widget.labelDetails?.callToAction ?? "",
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        )
      ],
    );
  }
}
