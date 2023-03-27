import 'package:device_info_plus/device_info_plus.dart';
import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_state.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/repoistory/eirs_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'launcher_event.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  EirsRepository eirsRepository = EirsRepository();

  LauncherBloc() : super(LauncherInitialState()) {
    on<LauncherInitEvent>(mapEventToState);
  }

  void mapEventToState(LauncherEvent event, Emitter<LauncherState> emit) async {
    emit(LauncherLoadingState());
    if (event is LauncherInitEvent) {
      try {
        DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        DeviceDetailsReq deviceDetailsReq = _readAndroidBuildData(
            event.languageType ?? StringConstants.englishCode,
            await deviceInfoPlugin.androidInfo);
        DeviceDetailsRes deviceDetailsRes =
            await eirsRepository.deviceDetailsReq(deviceDetailsReq);
        emit(LauncherLoadedState(deviceDetailsRes));
      } catch (e) {
        emit(LauncherErrorState(e.toString()));
      }
    }
  }

  DeviceDetailsReq _readAndroidBuildData(
      String languageType, AndroidDeviceInfo androidDeviceInfo) {
    return DeviceDetailsReq(
      osType: StringConstants.androidOs,
      deviceId: androidDeviceInfo.id,
      languageType: languageType,
      deviceDetails: AndroidDeviceDetails(
          versionCode: androidDeviceInfo.version.sdkInt,
          versionName: androidDeviceInfo.version.codename,
          codename: androidDeviceInfo.version.codename,
          brand: androidDeviceInfo.brand,
          device: androidDeviceInfo.device,
          display: androidDeviceInfo.display,
          hardware: androidDeviceInfo.hardware,
          id: androidDeviceInfo.id,
          host: androidDeviceInfo.host,
          manufacturer: androidDeviceInfo.manufacturer,
          manufacturermodel: androidDeviceInfo.model,
          product: androidDeviceInfo.product,
          fingerprint: androidDeviceInfo.fingerprint,
          tags: androidDeviceInfo.tags,
          type: androidDeviceInfo.type,
          isPhysicalDevice: androidDeviceInfo.isPhysicalDevice,
          systemFeature: androidDeviceInfo.systemFeatures,
          serialNumber: androidDeviceInfo.serialNumber,
          displayWidthInches: androidDeviceInfo.displayMetrics.widthInches,
          displayHeightInches: androidDeviceInfo.displayMetrics.heightInches,
          baseOS: androidDeviceInfo.version.baseOS),
    );
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
