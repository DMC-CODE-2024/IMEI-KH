// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_country_ip_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckCountryIPRes _$CheckCountryIPResFromJson(Map<String, dynamic> json) =>
    CheckCountryIPRes(
      statusCode: json['statusCode'] as int,
      statusMessage: json['statusMessage'] as String?,
      countryCode: json['countryCode'] as String?,
      countryName: json['countryName'] as String?,
    );

Map<String, dynamic> _$CheckCountryIPResToJson(CheckCountryIPRes instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'statusMessage': instance.statusMessage,
      'countryCode': instance.countryCode,
      'countryName': instance.countryName,
    };
