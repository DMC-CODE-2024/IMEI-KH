import 'package:eirs/features/check_imei/data/models/check_imei_res.dart';
import 'package:json_annotation/json_annotation.dart';
part 'multi_imei_res.g.dart';

@JsonSerializable()
class MultiImeiRes {
  String imei;
  CheckImeiRes checkImeiRes;

  MultiImeiRes({required this.imei, required this.checkImeiRes});

  factory MultiImeiRes.fromJson(Map<String, dynamic> json) => _$MultiImeiResFromJson(json);

  Map<String, dynamic> toJson() => _$MultiImeiResToJson(this);
}
