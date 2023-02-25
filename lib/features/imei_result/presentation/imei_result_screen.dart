import 'dart:convert';

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

class ImeiResultScreen extends StatefulWidget {
  const ImeiResultScreen({super.key, required this.title});

  final String title;

  @override
  State<ImeiResultScreen> createState() => _ImeiResultScreenState();
}

class _ImeiResultScreenState extends State<ImeiResultScreen> {
  List<DeviceDetails> deviceList = [];

  @override
  Widget build(BuildContext context) {
    bool isImeiValid = true;
    String response =
        '{"BrandName": "Samsung", "ModelName": "SamsungA30", "manufacture": "Samsung Korea","DeviceType": "Smartphone","MarketingName": "Samsung Galaxy M21"}';
    final Map<String, dynamic> data = json.decode(response);
    return Scaffold(
        appBar: ResultAppBar(title: "Result", callback: (value) {}),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Text(
                  StringConstants.imeiInfo,
                  style: TextStyle(fontSize: 20.0, color: AppColors.secondary),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Column(
                    children: [
                      SvgPicture.asset((isImeiValid == true)
                          ? ImageConstants.imeiValidIcon
                          : ImageConstants.imeiInValidIcon),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          (isImeiValid == true) ? "Valid" : "InValid",
                          style: TextStyle(fontSize: 24.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "IMEI",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      "8932720232083",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              if (isImeiValid)
                DeviceDetailList(data: data)
              else
                const InvalidImeiResult(),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: AppButton(
                  isLoading: false,
                  child: Text("Check other IMEI"),
                  onPressed: () => {},
                ),
              )
            ],
          ),
        ));
  }
}
