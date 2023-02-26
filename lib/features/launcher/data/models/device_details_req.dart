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
  String codename;
  String baseOS;
  String brand;
  String device;
  String display;
  String hardware;
  String host;
  String id;
  String manufacturer;
  String manufacturermodel;
  String product;
  String serialNumber;

  AndroidDeviceDetails(
      {required this.versionCode,
      required this.versionName,
      required this.baseOS,
      required this.codename,
      required this.brand,
      required this.device,
      required this.display,
      required this.hardware,
      required this.id,
      required this.host,
      required this.manufacturer,
      required this.manufacturermodel,
      required this.product,
      required this.serialNumber});

  factory AndroidDeviceDetails.fromJson(Map<String, dynamic> json) =>
      _$AndroidDeviceDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AndroidDeviceDetailsToJson(this);
}
