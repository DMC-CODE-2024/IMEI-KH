import 'dart:convert';
import 'package:eirs/constants/constants.dart';
import 'package:eirs/features/component/app_bar_with_title.dart';
import 'package:eirs/features/component/error_page.dart';
import 'package:eirs/features/history/data/business_logic/device_history_bloc.dart';
import 'package:eirs/features/history/data/business_logic/device_history_state.dart';
import 'package:eirs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../helper/app_states_notifier.dart';
import '../../../persistent/database_helper.dart';
import '../../../theme/hex_color.dart';
import '../../component/custom_progress_indicator.dart';
import '../../launcher/data/models/device_details_res.dart';
import '../data/business_logic/device_history_event.dart';

class DeviceHistoryScreen extends StatefulWidget {
  const DeviceHistoryScreen({super.key});

  @override
  State<DeviceHistoryScreen> createState() => _DeviceHistoryScreenState();
}

class _DeviceHistoryScreenState extends State<DeviceHistoryScreen> {
  LabelDetails? labelDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DeviceHistoryBloc>(context).add(DeviceHistoryInitEvent());
    return Scaffold(
      appBar: AppBarWithTitleOnly(title: labelDetails?.history ?? ""),
      body: BlocConsumer<DeviceHistoryBloc, DeviceHistoryState>(
        builder: (context, state) {
          if (state is DeviceHistoryLoadingState) {
            return CustomProgressIndicator(
                labelDetails: labelDetails, textColor: Colors.black);
          }
          if (state is DeviceHistoryLoadedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _listWidget(state.deviceHistory),
            );
          }
          if (state is NoDataDeviceHistoryState) {
            return Center(
              child: Text(
                labelDetails?.noDataFound ?? StringConstants.noDataFound,
                style: const TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            );
          }
          if (state is DeviceHistoryErrorState) {
            return ErrorPage(
              labelDetails: labelDetails,
            );
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
            padding: const EdgeInsets.only(top: 5),
            child: _validImeiWidget(
                context,
                key,
                deviceDetail[DatabaseHelper.columnDate],
                deviceDetail[DatabaseHelper.columnTime],
                json.decode(deviceDetail[DatabaseHelper.columnDeviceDetails]),
                deviceDetail[DatabaseHelper.columnCompliantStatus],
                deviceDetail[DatabaseHelper.columnMessage],
                deviceDetail[DatabaseHelper.columnStatusColor]),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: _invalidImeiWidget(
              context,
              key,
              deviceDetail[DatabaseHelper.columnDate],
              deviceDetail[DatabaseHelper.columnTime],
              labelDetails,
              deviceDetail[DatabaseHelper.columnCompliantStatus],
              deviceDetail[DatabaseHelper.columnStatusColor],
              deviceDetail[DatabaseHelper.columnMessage],
            ),
          );
        }
      },
    );
  }
}

Widget _validImeiWidget(
    BuildContext context,
    String imei,
    String date,
    String time,
    Map<String, dynamic>? deviceDetails,
    String? compliantStatus,
    String? message,
    String? statusColor) {
  return Container(
    color: AppColors.historyBg,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: ExpansionTile(
          title: Row(
            children: [
              SvgPicture.asset(
                ImageConstants.validIcon,
                color: HexColor(statusColor ?? validStatusColor),
                width: 40,
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
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
              )
            ],
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    compliantStatus ?? "",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                ),
                Text(
                  message ?? "",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black),
                ),
                if (deviceDetails != null) _deviceInfoListWidget(deviceDetails)
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _deviceInfoListWidget(Map<String, dynamic> values) {
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
              Expanded(
                child: Text(
                  key,
                  style:
                      TextStyle(fontSize: 14, color: AppColors.historyTxtColor),
                ),
              ),
              Expanded(
                flex: 2,
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

Widget _invalidImeiWidget(
    BuildContext context,
    String imei,
    String date,
    String time,
    LabelDetails? labelDetails,
    String? compliantStatus,
    String? statusColor,
    String? message) {
  var invalidImeiMsg = labelDetails?.imeiNotPer3gpp ?? "";
  if (message == "null" || message == null) {
    labelDetails?.imeiNotPer3gpp;
  } else {
    invalidImeiMsg = message;
  }
  return Container(
    color: AppColors.historyBg,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: ExpansionTile(
          title: Row(
            children: [
              SvgPicture.asset(
                ImageConstants.invalidIcon,
                color: HexColor(statusColor ?? invalidStatusColor),
                width: 40,
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
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
              )
            ],
          ),
          children: <Widget>[
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    compliantStatus ?? "",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      labelDetails?.remark ?? "",
                      style: TextStyle(
                          fontSize: 14, color: AppColors.historyTxtColor),
                    ),
                  ),
                  Text(
                      invalidImeiMsg,
                      style: TextStyle(
                          fontSize: 14, color: AppColors.historyTxtColor),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
