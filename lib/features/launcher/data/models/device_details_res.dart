import 'package:json_annotation/json_annotation.dart';

part 'device_details_res.g.dart';

@JsonSerializable()
class DeviceDetailsRes {
  String languageType;
  LabelDetails labelDetails;

  DeviceDetailsRes({required this.languageType, required this.labelDetails});

  factory DeviceDetailsRes.fromJson(Map<String, dynamic> json) =>
      _$DeviceDetailsResFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDetailsResToJson(this);
}

@JsonSerializable()
class LabelDetails {
  String imeiLabel;
  String inputFieldLabel;
  String enterImei;

  LabelDetails(
      {required this.imeiLabel,
      required this.inputFieldLabel,
      required this.enterImei});

  factory LabelDetails.fromJson(Map<String, dynamic> json) =>
      _$LabelDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$LabelDetailsToJson(this);
}
