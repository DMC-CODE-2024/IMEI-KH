import 'package:json_annotation/json_annotation.dart';
part 'device_details_req.g.dart';

@JsonSerializable()
class DeviceDetailsReq {
  String osType;
  String deviceId;
  AndroidDeviceDetails deviceDetails;

  DeviceDetailsReq(
      {required this.osType,
      required this.deviceId,
      required this.deviceDetails});

  factory DeviceDetailsReq.fromJson(Map<String, dynamic> json) =>
      _$DeviceDetailsReqFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDetailsReqToJson(this);
}

@JsonSerializable()
class AndroidDeviceDetails {
  int versionCode;
  String versionName;

  AndroidDeviceDetails({required this.versionCode, required this.versionName});

  factory AndroidDeviceDetails.fromJson(Map<String, dynamic> json) =>
      _$AndroidDeviceDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AndroidDeviceDetailsToJson(this);
}
