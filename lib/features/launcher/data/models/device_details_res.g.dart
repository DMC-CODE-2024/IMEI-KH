// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_details_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDetailsRes _$DeviceDetailsResFromJson(Map<String, dynamic> json) =>
    DeviceDetailsRes(
      languageType: json['languageType'] as String,
      labelDetails:
          LabelDetails.fromJson(json['labelDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceDetailsResToJson(DeviceDetailsRes instance) =>
    <String, dynamic>{
      'languageType': instance.languageType,
      'labelDetails': instance.labelDetails,
    };

LabelDetails _$LabelDetailsFromJson(Map<String, dynamic> json) => LabelDetails(
      imeiLabel: json['imeiLabel'] as String,
      inputFieldLabel: json['inputFieldLabel'] as String,
      enterImei: json['enterImei'] as String,
    );

Map<String, dynamic> _$LabelDetailsToJson(LabelDetails instance) =>
    <String, dynamic>{
      'imeiLabel': instance.imeiLabel,
      'inputFieldLabel': instance.inputFieldLabel,
      'enterImei': instance.enterImei,
    };
