import 'dart:io';

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
        DeviceDetailsReq deviceDetailsReq;
        if (Platform.isIOS) {
          deviceDetailsReq = _readIosBuildData(event.languageType ?? StringConstants.englishCode, await deviceInfoPlugin.iosInfo);
        }else{
          deviceDetailsReq = _readAndroidBuildData(event.languageType ?? StringConstants.englishCode, await deviceInfoPlugin.androidInfo);
        }
        DeviceDetailsRes deviceDetailsRes =
            await eirsRepository.deviceDetailsReq(deviceDetailsReq);
        emit(LauncherLoadedState(deviceDetailsRes));
      } catch (e) {
        emit(LauncherErrorState(e.toString()));
      }
    }
  }

  DeviceDetailsReq _readAndroidBuildData(String languageType, AndroidDeviceInfo androidDeviceInfo) {
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


  DeviceDetailsReq _readIosBuildData(String languageType, IosDeviceInfo iosDeviceInfo) {
    return DeviceDetailsReq(
      osType: StringConstants.iOSOs,
      deviceId: iosDeviceInfo.identifierForVendor ?? "",
      languageType: languageType,
      deviceDetails: IosDeviceDetails(
          name:iosDeviceInfo.name,
        systemName:iosDeviceInfo.systemName,
        systemVersion:iosDeviceInfo.systemVersion,
        model:iosDeviceInfo.model,
        localizedModel:iosDeviceInfo.localizedModel,
        id:iosDeviceInfo.identifierForVendor,
        isPhysicalDevice:iosDeviceInfo.isPhysicalDevice,
        sysname:iosDeviceInfo.utsname.sysname,
        nodename:iosDeviceInfo.utsname.nodename,
        release:iosDeviceInfo.utsname.release,
        version:iosDeviceInfo.utsname.version,
        machine:iosDeviceInfo.utsname.machine
    ));
  }

}
