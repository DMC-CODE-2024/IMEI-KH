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
