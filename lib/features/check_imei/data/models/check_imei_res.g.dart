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
      ..deviceDetails = json['deviceDetails'] as Map<String, dynamic>?
      ..validImei = json['validImei'] as bool;

Map<String, dynamic> _$CheckImeiResultToJson(CheckImeiResult instance) =>
    <String, dynamic>{
      'message': instance.message,
      'deviceDetails': instance.deviceDetails,
      'validImei': instance.validImei,
    };