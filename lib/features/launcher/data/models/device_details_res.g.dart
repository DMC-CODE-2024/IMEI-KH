// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_details_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDetailsRes _$DeviceDetailsResFromJson(Map<String, dynamic> json) =>
    DeviceDetailsRes()
      ..languageType = json['languageType'] as String
      ..labelDetails =
          LabelDetails.fromJson(json['labelDetails'] as Map<String, dynamic>);

Map<String, dynamic> _$DeviceDetailsResToJson(DeviceDetailsRes instance) =>
    <String, dynamic>{
      'languageType': instance.languageType,
      'labelDetails': instance.labelDetails,
    };

LabelDetails _$LabelDetailsFromJson(Map<String, dynamic> json) => LabelDetails()
  ..findImei = json['find_imei'] as String
  ..getImeiInfo = json['get_imei_information'] as String
  ..imeiDetails = json['imei_details'] as String
  ..enterImei = json['enter_imei'] as String
  ..optionA = json['option_a'] as String;

Map<String, dynamic> _$LabelDetailsToJson(LabelDetails instance) =>
    <String, dynamic>{
      'find_imei': instance.findImei,
      'get_imei_information': instance.getImeiInfo,
      'imei_details': instance.imeiDetails,
      'enter_imei': instance.enterImei,
      'option_a': instance.optionA,
    };
