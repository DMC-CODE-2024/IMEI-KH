import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eirs/constants/constants.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/network/eirs_api_client.dart';
import 'package:intl/intl.dart';

import '../features/check_imei/data/models/check_imei_req.dart';
import '../features/check_imei/data/models/check_imei_res.dart';
import '../main.dart';
import '../persistent/database_helper.dart';

class EirsRepository {
  static final EirsRepository _singletonUserRepository =
      EirsRepository._internal();

  factory EirsRepository() {
    return _singletonUserRepository;
  }

  EirsRepository._internal();

  // Save device details
  Future<dynamic> preInitReq(String deviceId) async {
    return await EirsApiClient(Dio(), baseUrl: baseUrl).preInit(deviceId);
  }

  // Save device details
  Future<dynamic> deviceDetailsReq(DeviceDetailsReq deviceDetailsReq) async {
    return await EirsApiClient(Dio(), baseUrl: baseUrl)
        .deviceDetailReq(deviceDetailsReq);
  }

  // check imei
  Future<dynamic> checkImei(CheckImeiReq checkImeiReq) async {
    return await EirsApiClient(Dio(), baseUrl: baseUrl).checkImei(checkImeiReq);
  }

  Future<dynamic> getLanguage(String featureName, String language) async {
    return await EirsApiClient(Dio(), baseUrl: baseUrl)
        .languageRetriever(featureName, language);
  }

  Future<List<Map<String, dynamic>>> getDeviceHistory() async {
    return await dbHelper.getDeviceHistory();
  }

  Future<void> insertDeviceDetail(
      String imei, CheckImeiRes checkImeiRes) async {
    bool isRecordExist = await dbHelper.isImeiExists(imei);
    var dt = DateTime.now();
    var dateFormatter = DateFormat('yyyy-MM-dd');
    var timeFormatter = DateFormat('HH:mm');
    bool isValidImei = checkImeiRes.result?.validImei ?? false;
    if (!isRecordExist) {
      // row to insert
      Map<String, dynamic>? deviceDetails = checkImeiRes.result?.deviceDetails;
      Map<String, dynamic> row = {
        DatabaseHelper.columnImei: imei,
        DatabaseHelper.columnDeviceDetails: jsonEncode(deviceDetails),
        DatabaseHelper.columnMessage: checkImeiRes.result?.message,
        DatabaseHelper.columnCompliantStatus:
            checkImeiRes.result?.complianceStatus,
        DatabaseHelper.columnStatusColor: checkImeiRes.result?.statusColor,
        DatabaseHelper.columnIsValid: isValidImei ? 1 : 0,
        DatabaseHelper.columnTimeStamp: "${dt.millisecondsSinceEpoch}",
        DatabaseHelper.columnDate: dateFormatter.format(dt),
        DatabaseHelper.columnTime: timeFormatter.format(dt)
      };
      await dbHelper.insert(row);
    } else {
      int deviceStatus = isValidImei ? 1 : 0;
      List<Map<String, dynamic>> existingData =
          await dbHelper.getImeiData(imei);
      String? statusColor = checkImeiRes.result?.statusColor;
      if (existingData.isNotEmpty) {
        Map<String, dynamic> deviceDetails = existingData.first;
        int existingStatus = deviceDetails.values.elementAt(5);
        if (deviceStatus != existingStatus) {
          await dbHelper.updateDeviceDetailsWithStatus(
              jsonEncode(checkImeiRes.result?.deviceDetails),
              checkImeiRes.result?.message,
              checkImeiRes.result?.complianceStatus,
              (statusColor != null)
                  ? statusColor
                  : (isValidImei)
                      ? validStatusColor
                      : invalidStatusColor,
              deviceStatus,
              "${dt.millisecondsSinceEpoch}",
              dateFormatter.format(dt),
              timeFormatter.format(dt),
              imei);
        } else {
          await dbHelper.updateDeviceDetails(
              jsonEncode(checkImeiRes.result?.deviceDetails),
              checkImeiRes.result?.complianceStatus,
              checkImeiRes.result?.message,
              (statusColor != null)
                  ? statusColor
                  : (isValidImei)
                      ? validStatusColor
                      : invalidStatusColor,
              "${dt.millisecondsSinceEpoch}",
              dateFormatter.format(dt),
              timeFormatter.format(dt),
              imei);
        }
      }
    }
  }
}
