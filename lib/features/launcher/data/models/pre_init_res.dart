import 'package:json_annotation/json_annotation.dart';

part 'pre_init_res.g.dart';

@JsonSerializable()
class PreInitRes {
  String? deviceId;
  String? baseUrl;

  PreInitRes();

  factory PreInitRes.fromJson(Map<String, dynamic> json) =>
      _$PreInitResFromJson(json);

  Map<String, dynamic> toJson() => _$PreInitResToJson(this);
}