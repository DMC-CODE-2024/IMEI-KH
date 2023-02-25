// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_details_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDetailsReq _$DeviceDetailsReqFromJson(Map<String, dynamic> json) =>
    DeviceDetailsReq(
      osType: json['osType'] as String,
      deviceId: json['deviceId'] as String,
      deviceDetails: AndroidDeviceDetails.fromJson(
          json['deviceDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceDetailsReqToJson(DeviceDetailsReq instance) =>
    <String, dynamic>{
      'osType': instance.osType,
      'deviceId': instance.deviceId,
      'deviceDetails': instance.deviceDetails,
    };

AndroidDeviceDetails _$AndroidDeviceDetailsFromJson(
        Map<String, dynamic> json) =>
    AndroidDeviceDetails(
      versionCode: json['versionCode'] as int,
      versionName: json['versionName'] as String,
    );

Map<String, dynamic> _$AndroidDeviceDetailsToJson(
        AndroidDeviceDetails instance) =>
    <String, dynamic>{
      'versionCode': instance.versionCode,
      'versionName': instance.versionName,
    };
