import 'package:json_annotation/json_annotation.dart';

part 'check_country_ip_res.g.dart';

@JsonSerializable()
class CheckCountryIPRes {
  int statusCode;
  String? statusMessage;
  String? countryCode;
  String? countryName;

  CheckCountryIPRes({required this.statusCode, required this.statusMessage,required this.countryCode,required this.countryName});

  factory CheckCountryIPRes.fromJson(Map<String, dynamic> json) =>
      _$CheckCountryIPResFromJson(json);

  Map<String, dynamic> toJson() => _$CheckCountryIPResToJson(this);
}