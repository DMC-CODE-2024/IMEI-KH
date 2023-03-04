import 'package:json_annotation/json_annotation.dart';
part 'check_imei_req.g.dart';
@JsonSerializable()
class CheckImeiReq {
  String imei;
  String operator;
  String language;
  String channel;

  CheckImeiReq({required this.imei, required this.operator, required this.language,required this.channel});

  factory CheckImeiReq.fromJson(Map<String, dynamic> json) =>
      _$CheckImeiReqFromJson(json);

  Map<String, dynamic> toJson() => _$CheckImeiReqToJson(this);
}
