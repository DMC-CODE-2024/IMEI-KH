// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_details_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDetailsReq _$DeviceDetailsReqFromJson(Map<String, dynamic> json) =>
    DeviceDetailsReq(
      osType: json['osType'] as String,
      deviceId: json['deviceId'] as String,
      languageType: json['languageType'] as String,
      deviceDetails: AndroidDeviceDetails.fromJson(
          json['deviceDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceDetailsReqToJson(DeviceDetailsReq instance) =>
    <String, dynamic>{
      'osType': instance.osType,
      'deviceId': instance.deviceId,
      'languageType': instance.languageType,
      'deviceDetails': instance.deviceDetails,
    };

AndroidDeviceDetails _$AndroidDeviceDetailsFromJson(
        Map<String, dynamic> json) =>
    AndroidDeviceDetails(
      versionCode: json['versionCode'] as int,
      versionName: json['versionName'] as String,
      codename: json['codename'] as String,
      brand: json['brand'] as String,
      device: json['device'] as String,
      display: json['display'] as String,
      hardware: json['hardware'] as String,
      id: json['id'] as String,
      host: json['host'] as String,
      manufacturer: json['manufacturer'] as String,
      manufacturermodel: json['manufacturermodel'] as String,
      product: json['product'] as String,
      fingerprint: json['fingerprint'] as String?,
      tags: json['tags'] as String?,
      type: json['type'] as String?,
      isPhysicalDevice: json['isPhysicalDevice'] as bool?,
      systemFeature: (json['systemFeature'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      serialNumber: json['serialNumber'] as String?,
      displayWidthInches: (json['displayWidthInches'] as num?)?.toDouble(),
      displayHeightInches: (json['displayHeightInches'] as num?)?.toDouble(),
      baseOS: json['baseOS'] as String?,
    );

Map<String, dynamic> _$AndroidDeviceDetailsToJson(
        AndroidDeviceDetails instance) =>
    <String, dynamic>{
      'versionCode': instance.versionCode,
      'versionName': instance.versionName,
      'codename': instance.codename,
      'brand': instance.brand,
      'device': instance.device,
      'display': instance.display,
      'hardware': instance.hardware,
      'host': instance.host,
      'id': instance.id,
      'manufacturer': instance.manufacturer,
      'manufacturermodel': instance.manufacturermodel,
      'product': instance.product,
      'fingerprint': instance.fingerprint,
      'tags': instance.tags,
      'type': instance.type,
      'isPhysicalDevice': instance.isPhysicalDevice,
      'systemFeature': instance.systemFeature,
      'serialNumber': instance.serialNumber,
      'displayWidthInches': instance.displayWidthInches,
      'displayHeightInches': instance.displayHeightInches,
      'baseOS': instance.baseOS,
    };
