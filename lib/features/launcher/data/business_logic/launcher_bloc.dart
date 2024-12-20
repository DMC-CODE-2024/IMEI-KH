import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eirs/constants/constants.dart';
import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_state.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/features/launcher/data/models/pre_init_res.dart';
import 'package:eirs/helper/shared_pref.dart';
import 'package:eirs/repoistory/eirs_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'launcher_event.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  EirsRepository eirsRepository = EirsRepository();
  DeviceDetailsReq? deviceDetailsReq;

  LauncherBloc() : super(LauncherInitialState()) {
    on<LauncherInitEvent>(mapEventToState);
  }

  void mapEventToState(LauncherEvent event, Emitter<LauncherState> emit) async {
    if (event is LauncherInitEvent) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (deviceDetailsReq == null) {
        if (Platform.isIOS) {
          deviceDetailsReq = _readIosBuildData(
              event.languageType ?? StringConstants.englishCode,
              await deviceInfoPlugin.iosInfo);
        } else {
          deviceDetailsReq = _readAndroidBuildData(
              event.languageType ?? StringConstants.englishCode,
              await deviceInfoPlugin.androidInfo);
        }
      }
      var deviceId = deviceDetailsReq?.deviceId;
      if (deviceDetailsReq != null && deviceId != null) {
        //Store device id
        setDeviceId(deviceId);
        if (event.requestCode == preInitReqCode) {
          emit(LauncherPreInitLoadingState());
          try {
            //Network request for pre-init api
            PreInitRes preInitRes = await eirsRepository.preInitReq(deviceId);
            //update base url for further apis request
            baseUrl = preInitRes.baseUrl ?? defaultUrl;
            emit(LauncherPreInitLoadedState());
          } catch (e) {
            emit(LauncherPreInitErrorState(e.toString()));
          }
        } else {
          emit(LauncherLoadingState());
          try {
            //Invoke init api request with device details payload and getting label details in response
            DeviceDetailsRes deviceDetailsRes =
                await eirsRepository.deviceDetailsReq(deviceDetailsReq!);
            deviceDetailsRes.labelDetails?.featureMenu =
                deviceDetailsRes.featureMenu;
            emit(LauncherLoadedState(deviceDetailsRes));
          } catch (e) {
            emit(LauncherErrorState(e.toString()));
          }
        }
      }
    }
  }

  //Getting android device basic details
  DeviceDetailsReq _readAndroidBuildData(
      String languageType, AndroidDeviceInfo androidDeviceInfo) {
    return DeviceDetailsReq(
      osType: StringConstants.androidOs,
      deviceId: androidDeviceInfo.id,
      languageType: languageType,
      deviceDetails: AndroidDeviceDetails(
          brand: androidDeviceInfo.brand,
          id: androidDeviceInfo.id,
          manufacturer: androidDeviceInfo.manufacturer,
          manufacturermodel: androidDeviceInfo.model,
          isPhysicalDevice: androidDeviceInfo.isPhysicalDevice),
    );
  }

  //Getting iOS device details
  DeviceDetailsReq _readIosBuildData(
      String languageType, IosDeviceInfo iosDeviceInfo) {
    return DeviceDetailsReq(
        osType: StringConstants.iOSOs,
        deviceId: iosDeviceInfo.identifierForVendor ?? "",
        languageType: languageType,
        deviceDetails: IosDeviceDetails(
            name: iosDeviceInfo.name,
            systemName: iosDeviceInfo.systemName,
            systemVersion: iosDeviceInfo.systemVersion,
            model: iosDeviceInfo.model,
            localizedModel: iosDeviceInfo.localizedModel,
            id: iosDeviceInfo.identifierForVendor,
            isPhysicalDevice: iosDeviceInfo.isPhysicalDevice,
            sysname: iosDeviceInfo.utsname.sysname,
            nodename: iosDeviceInfo.utsname.nodename,
            release: iosDeviceInfo.utsname.release,
            version: iosDeviceInfo.utsname.version,
            machine: iosDeviceInfo.utsname.machine));
  }
}
