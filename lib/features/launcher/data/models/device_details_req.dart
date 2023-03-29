import 'package:json_annotation/json_annotation.dart';

part 'device_details_req.g.dart';

@JsonSerializable()
class DeviceDetailsReq {
  String osType;
  String deviceId;
  String languageType;
  dynamic deviceDetails;

  DeviceDetailsReq(
      {required this.osType,
      required this.deviceId,
      required this.languageType,
      required this.deviceDetails});

  factory DeviceDetailsReq.fromJson(Map<String, dynamic> json) =>
      _$DeviceDetailsReqFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDetailsReqToJson(this);
}

@JsonSerializable()
class IosDeviceDetails{
String? name;
String? systemName;
String? systemVersion;
String? model;
String? localizedModel;
String? id;
bool? isPhysicalDevice;
String? sysname;
String? nodename;
String? release;
String? version;
String? machine;
IosDeviceDetails({this.name,this.systemName,this.systemVersion,this.model,this.localizedModel,this.id
    ,this.isPhysicalDevice,this.sysname,this.nodename,this.release,this.version,this.machine});

factory IosDeviceDetails.fromJson(Map<String, dynamic> json) =>
    _$IosDeviceDetailsFromJson(json);

Map<String, dynamic> toJson() => _$IosDeviceDetailsToJson(this);
}

@JsonSerializable()
class AndroidDeviceDetails {
  int versionCode;
  String versionName;
  String codename;
  String brand;
  String device;
  String display;
  String hardware;
  String host;
  String id;
  String manufacturer;
  String manufacturermodel;
  String product;
  String? fingerprint;
  String? tags;
  String? type;
  bool? isPhysicalDevice;
  List<String>? systemFeature;
  String? serialNumber;
  double? displayWidthInches;
  double? displayHeightInches;
  String? baseOS;

  AndroidDeviceDetails(
      {required this.versionCode,
      required this.versionName,
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
      this.fingerprint,
      this.tags,
      this.type,
      this.isPhysicalDevice,
      this.systemFeature,
      this.serialNumber,
      this.displayWidthInches,
      this.displayHeightInches,
      this.baseOS});

  factory AndroidDeviceDetails.fromJson(Map<String, dynamic> json) =>
      _$AndroidDeviceDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AndroidDeviceDetailsToJson(this);
}
