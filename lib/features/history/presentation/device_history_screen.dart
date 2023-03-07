import 'dart:convert';

import 'package:eirs/features/component/app_bar_with_title.dart';
import 'package:eirs/features/history/data/business_logic/device_history_bloc.dart';
import 'package:eirs/features/history/data/business_logic/device_history_state.dart';
import 'package:eirs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../persistent/database_helper.dart';
import '../../component/custom_progress_indicator.dart';
import '../data/business_logic/device_history_event.dart';

class DeviceHistoryScreen extends StatefulWidget {
  const DeviceHistoryScreen({super.key});

  @override
  State<DeviceHistoryScreen> createState() => _DeviceHistoryScreenState();
}

class _DeviceHistoryScreenState extends State<DeviceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DeviceHistoryBloc>(context).add(DeviceHistoryInitEvent());
    return Scaffold(
      appBar: const AppBarWithTitleOnly(title: StringConstants.history),
      body: BlocConsumer<DeviceHistoryBloc, DeviceHistoryState>(
        builder: (context, state) {
          if (state is DeviceHistoryLoadingState) {
            return const CustomProgressIndicator(textColor: Colors.black);
          }
          if (state is DeviceHistoryLoadedState) {
            return _listWidget(state.deviceHistory);
          }
          return Container();
        },
        listener: (context, state) {
          if (state is DeviceHistoryLoadedState) {}
          if (state is DeviceHistoryErrorState) {}
        },
      ),
    );
  }

  Widget _listWidget(List<Map<String, dynamic>> values) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> deviceDetail = values.elementAt(index);
        String key = deviceDetail[DatabaseHelper.columnImei];
        int isValidImei = deviceDetail[DatabaseHelper.columnIsValid];
        if (isValidImei == 1) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: _validImeiWidget(
                context,
                key,
                deviceDetail[DatabaseHelper.columnDate],
                deviceDetail[DatabaseHelper.columnTime],
                json.decode(deviceDetail[DatabaseHelper.columnDeviceDetails])),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: _invalidImeiWidget(
                key,
                deviceDetail[DatabaseHelper.columnDate],
                deviceDetail[DatabaseHelper.columnTime]),
          );
        }
      },
    );
  }
}

Widget _validImeiWidget(BuildContext context, String imei, String date,
    String time, Map<String, dynamic> deviceDetails) {
  return Container(
    color: AppColors.historyBg,
    padding: const EdgeInsets.all(15),
    child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            child: ExpansionTile(
              title: Row(
                children: [
                  SvgPicture.asset(ImageConstants.mobileOnIcon),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${StringConstants.imei}  $imei",
                            style: TextStyle(
                                fontSize: 14, color: AppColors.historyTxtColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                Text(
                                  date,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.dateTimeTxtColor),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.dateTimeTxtColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              children: [_listWidget(deviceDetails)],
            ))),
  );
}

Widget _listWidget(Map<String, dynamic> values) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: values.length,
    itemBuilder: (BuildContext context, int index) {
      String key = values.keys.elementAt(index);
      String value = values.values.elementAt(index);
      return SizedBox(
        height: 36,
        child: ListTile(
          title: Row(
            children: [
              Text(
                key,
                style:
                    TextStyle(fontSize: 14, color: AppColors.historyTxtColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  value,
                  style:
                      TextStyle(fontSize: 14, color: AppColors.historyTxtColor),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget _invalidImeiWidget(String imei, String date, String time) {
  return Container(
    color: AppColors.historyBg,
    padding: const EdgeInsets.all(15),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(ImageConstants.mobileOffIcon),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${StringConstants.invalidImei}  $imei",
                  style:
                      TextStyle(fontSize: 14, color: AppColors.historyTxtColor),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                            fontSize: 14, color: AppColors.dateTimeTxtColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          time,
                          style: TextStyle(
                              fontSize: 12, color: AppColors.dateTimeTxtColor),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    StringConstants.remark,
                    style: TextStyle(
                        fontSize: 14, color: AppColors.historyTxtColor),
                  ),
                ),
                Text(
                  StringConstants.invalidImeiDesc,
                  style:
                      TextStyle(fontSize: 14, color: AppColors.historyTxtColor),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
