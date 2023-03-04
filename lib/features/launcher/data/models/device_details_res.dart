import 'package:json_annotation/json_annotation.dart';

part 'device_details_res.g.dart';

@JsonSerializable()
class DeviceDetailsRes {
  String languageType;

  DeviceDetailsRes({required this.languageType});

  factory DeviceDetailsRes.fromJson(Map<String, dynamic> json) =>
      _$DeviceDetailsResFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDetailsResToJson(this);
}
