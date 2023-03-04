import 'package:json_annotation/json_annotation.dart';

part 'device_details_res.g.dart';

@JsonSerializable()
class DeviceDetailsRes {
  late String languageType;
  late LabelDetails labelDetails;

  DeviceDetailsRes();

  factory DeviceDetailsRes.fromJson(Map<String, dynamic> json) =>
      _$DeviceDetailsResFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDetailsResToJson(this);
}


@JsonSerializable()
class LabelDetails{
  @JsonKey(name: 'find_imei')
  late String findImei;
  @JsonKey(name: 'get_imei_information')
  late String getImeiInfo;
  @JsonKey(name: 'imei_details')
  late String imeiDetails;
  @JsonKey(name: 'enter_imei')
  late String enterImei;
  @JsonKey(name: 'option_a')
  late String optionA;

  LabelDetails();

  factory LabelDetails.fromJson(Map<String, dynamic> json) => _$LabelDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$LabelDetailsToJson(this);
}