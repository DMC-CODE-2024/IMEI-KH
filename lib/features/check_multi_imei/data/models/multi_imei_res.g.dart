// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_imei_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiImeiRes _$MultiImeiResFromJson(Map<String, dynamic> json) => MultiImeiRes(
      imei: json['imei'] as String,
      checkImeiRes:
          CheckImeiRes.fromJson(json['checkImeiRes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MultiImeiResToJson(MultiImeiRes instance) =>
    <String, dynamic>{
      'imei': instance.imei,
      'checkImeiRes': instance.checkImeiRes,
    };
