import 'package:equatable/equatable.dart';
part 'android_device_details.g.dart';

class AndroidDeviceDetails extends Equatable {
  final String securityPatch;
  final String sdkInt;
  final String release;
  final String previewSdkInt;
  final String incremental;
  final String codename;
  final String baseOS;
  final String board;
  final String bootloader;
  final String brand;
  final String device;
  final String display;
  final String fingerprint;
  final String hardware;
  final String host;
  final String id;
  final String manufacturer;
  final String model;
  final String product;
  final String supported32BitAbis;
  final String supported64BitAbis;
  final String supportedAbis;
  final String tags;
  final String type;
  final String isPhysicalDevice;
  final String androidId;
  final String systemFeatures;

  const AndroidDeviceDetails(
      this.securityPatch,
      this.sdkInt,
      this.release,
      this.previewSdkInt,
      this.incremental,
      this.codename,
      this.baseOS,
      this.board,
      this.bootloader,
      this.brand,
      this.device,
      this.display,
      this.fingerprint,
      this.hardware,
      this.host,
      this.id,
      this.manufacturer,
      this.model,
      this.product,
      this.supported32BitAbis,
      this.supported64BitAbis,
      this.supportedAbis,
      this.tags,
      this.type,
      this.isPhysicalDevice,
      this.androidId,
      this.systemFeatures);

  @override
  List<Object?> get props => [
        securityPatch,
        sdkInt,
        release,
        previewSdkInt,
        incremental,
        codename,
        baseOS,
        board,
        bootloader,
        brand,
        device,
        display,
        fingerprint,
        hardware,
        host,
        id,
        manufacturer,
        model,
        product,
        supported32BitAbis,
        supported64BitAbis,
        supportedAbis,
        tags,
        type,
        isPhysicalDevice,
        androidId,
        systemFeatures
      ];

  factory AndroidDeviceDetails.fromJson(Map<String, dynamic> json) =>
      _$AndroidDeviceDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AndroidDeviceDetailsToJson(this);
}
