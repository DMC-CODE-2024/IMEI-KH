import 'package:json_annotation/json_annotation.dart';

part 'check_imei_req.g.dart';

@JsonSerializable()
class CheckImeiReq {
  String imei;
  String language;
  String channel;
  @JsonKey(name: 'device_id')
  String? deviceId;
  String osType;

  CheckImeiReq(
      {required this.imei, required this.language, required this.channel,required this.deviceId,required this.osType});

  factory CheckImeiReq.fromJson(Map<String, dynamic> json) =>
      _$CheckImeiReqFromJson(json);

  Map<String, dynamic> toJson() => _$CheckImeiReqToJson(this);
}
