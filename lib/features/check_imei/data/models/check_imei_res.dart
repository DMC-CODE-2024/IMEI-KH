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
  String? complianceStatus;
  String? message;
  Map<String, dynamic>? deviceDetails;
  bool validImei = false;
  @JsonKey(name: 'symbol_color')
  String? statusColor;

  CheckImeiResult();

  factory CheckImeiResult.fromJson(Map<String, dynamic> json) =>
      _$CheckImeiResultFromJson(json);

  Map<String, dynamic> toJson() => _$CheckImeiResultToJson(this);
}
