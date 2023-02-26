import 'package:json_annotation/json_annotation.dart';
part 'check_imei_req.g.dart';
@JsonSerializable()
class CheckImeiReq {
  String imei;
  String interfaces;
  String language;

  CheckImeiReq(
      {required this.imei, required this.interfaces, required this.language});

  factory CheckImeiReq.fromJson(Map<String, dynamic> json) =>
      _$CheckImeiReqFromJson(json);

  Map<String, dynamic> toJson() => _$CheckImeiReqToJson(this);
}
