// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_imei_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckImeiReq _$CheckImeiReqFromJson(Map<String, dynamic> json) => CheckImeiReq(
      imei: json['imei'] as String,
      interfaces: json['interfaces'] as String,
      language: json['language'] as String,
    );

Map<String, dynamic> _$CheckImeiReqToJson(CheckImeiReq instance) =>
    <String, dynamic>{
      'imei': instance.imei,
      'interfaces': instance.interfaces,
      'language': instance.language,
    };
