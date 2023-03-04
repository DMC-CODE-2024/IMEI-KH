import 'package:json_annotation/json_annotation.dart';

part 'check_imei_res.g.dart';

@JsonSerializable()
class CheckImeiRes {
  String? statusCode;
  String? statusMessage;
  String? language;
  CheckImeiResult? result;

  CheckImeiRes();

  factory CheckImeiRes.fromJson(Map<String, dynamic> json) =>
      _$CheckImeiResFromJson(json);

  Map<String, dynamic> toJson() => _$CheckImeiResToJson(this);
}

@JsonSerializable()
class CheckImeiResult {
  String? message;
  ScanImeiDeviceDetail? deviceDetails;

  CheckImeiResult();

  factory CheckImeiResult.fromJson(Map<String, dynamic> json) =>
      _$CheckImeiResultFromJson(json);

  Map<String, dynamic> toJson() => _$CheckImeiResultToJson(this);
}

@JsonSerializable()
class ScanImeiDeviceDetail {
  @JsonKey(name: 'Brand Name')
  String? brandName;
  @JsonKey(name: 'Model Name')
  String? modelName;
  @JsonKey(name: 'Manufacturer')
  String? manufacturer;
  @JsonKey(name: 'Marketing Name')
  String? marketingName;
  @JsonKey(name: 'Device Type')
  String? deviceType;

  ScanImeiDeviceDetail();

  factory ScanImeiDeviceDetail.fromJson(Map<String, dynamic> json) =>
      _$ScanImeiDeviceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ScanImeiDeviceDetailToJson(this);
}
