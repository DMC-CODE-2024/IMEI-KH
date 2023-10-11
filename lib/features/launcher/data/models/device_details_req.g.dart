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
      deviceDetails: json['deviceDetails'],
    );

Map<String, dynamic> _$DeviceDetailsReqToJson(DeviceDetailsReq instance) =>
    <String, dynamic>{
      'osType': instance.osType,
      'deviceId': instance.deviceId,
      'languageType': instance.languageType,
      'deviceDetails': instance.deviceDetails,
    };

IosDeviceDetails _$IosDeviceDetailsFromJson(Map<String, dynamic> json) =>
    IosDeviceDetails(
      name: json['name'] as String?,
      systemName: json['systemName'] as String?,
      systemVersion: json['systemVersion'] as String?,
      model: json['model'] as String?,
      localizedModel: json['localizedModel'] as String?,
      id: json['id'] as String?,
      isPhysicalDevice: json['isPhysicalDevice'] as bool?,
      sysname: json['sysname'] as String?,
      nodename: json['nodename'] as String?,
      release: json['release'] as String?,
      version: json['version'] as String?,
      machine: json['machine'] as String?,
    );

Map<String, dynamic> _$IosDeviceDetailsToJson(IosDeviceDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'systemName': instance.systemName,
      'systemVersion': instance.systemVersion,
      'model': instance.model,
      'localizedModel': instance.localizedModel,
      'id': instance.id,
      'isPhysicalDevice': instance.isPhysicalDevice,
      'sysname': instance.sysname,
      'nodename': instance.nodename,
      'release': instance.release,
      'version': instance.version,
      'machine': instance.machine,
    };

AndroidDeviceDetails _$AndroidDeviceDetailsFromJson(
        Map<String, dynamic> json) =>
    AndroidDeviceDetails(
      brand: json['brand'] as String,
      id: json['id'] as String,
      manufacturer: json['manufacturer'] as String,
      manufacturermodel: json['manufacturermodel'] as String,
      isPhysicalDevice: json['isPhysicalDevice'] as bool?,
    );

Map<String, dynamic> _$AndroidDeviceDetailsToJson(
        AndroidDeviceDetails instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'id': instance.id,
      'manufacturer': instance.manufacturer,
      'manufacturermodel': instance.manufacturermodel,
      'isPhysicalDevice': instance.isPhysicalDevice,
    };
