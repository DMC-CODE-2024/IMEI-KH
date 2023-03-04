// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_imei_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckImeiRes _$CheckImeiResFromJson(Map<String, dynamic> json) => CheckImeiRes()
  ..statusCode = json['statusCode'] as String?
  ..statusMessage = json['statusMessage'] as String?
  ..language = json['language'] as String?
  ..result = json['result'] == null
      ? null
      : CheckImeiResult.fromJson(json['result'] as Map<String, dynamic>);

Map<String, dynamic> _$CheckImeiResToJson(CheckImeiRes instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'statusMessage': instance.statusMessage,
      'language': instance.language,
      'result': instance.result,
    };

CheckImeiResult _$CheckImeiResultFromJson(Map<String, dynamic> json) =>
    CheckImeiResult()
      ..message = json['message'] as String?
      ..deviceDetails = json['deviceDetails'] == null
          ? null
          : ScanImeiDeviceDetail.fromJson(
              json['deviceDetails'] as Map<String, dynamic>);

Map<String, dynamic> _$CheckImeiResultToJson(CheckImeiResult instance) =>
    <String, dynamic>{
      'message': instance.message,
      'deviceDetails': instance.deviceDetails,
    };

ScanImeiDeviceDetail _$ScanImeiDeviceDetailFromJson(
        Map<String, dynamic> json) =>
    ScanImeiDeviceDetail()
      ..brandName = json['Brand Name'] as String?
      ..modelName = json['Model Name'] as String?
      ..manufacturer = json['Manufacturer'] as String?
      ..marketingName = json['Marketing Name'] as String?
      ..deviceType = json['Device Type'] as String?;

Map<String, dynamic> _$ScanImeiDeviceDetailToJson(
        ScanImeiDeviceDetail instance) =>
    <String, dynamic>{
      'Brand Name': instance.brandName,
      'Model Name': instance.modelName,
      'Manufacturer': instance.manufacturer,
      'Marketing Name': instance.marketingName,
      'Device Type': instance.deviceType,
    };
