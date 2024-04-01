import 'package:json_annotation/json_annotation.dart';

part 'check_country_ip_req.g.dart';

@JsonSerializable()
class CheckCountryIPReq {
  String ip;
  String? ipType;

  CheckCountryIPReq({required this.ip, required this.ipType});

  factory CheckCountryIPReq.fromJson(Map<String, dynamic> json) =>
      _$CheckCountryIPReqFromJson(json);

  Map<String, dynamic> toJson() => _$CheckCountryIPReqToJson(this);
}
