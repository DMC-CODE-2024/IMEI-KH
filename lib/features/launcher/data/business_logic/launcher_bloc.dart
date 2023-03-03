import 'package:device_info_plus/device_info_plus.dart';
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
        DeviceDetailsReq deviceDetailsReq =
            _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        print(deviceDetailsReq.toJson());
        print(deviceDetailsReq.deviceDetails.toJson());
        DeviceDetailsRes deviceDetailsRes =
            await eirsRepository.deviceDetailsReq(deviceDetailsReq);
        print(deviceDetailsRes.toJson());
        emit(LauncherLoadedState(deviceDetailsRes));
      } catch (e) {
        print("invoke error: ${e.toString()}");
        emit(LauncherErrorState(e.toString()));
      }
    }
  }

  DeviceDetailsReq _readAndroidBuildData(AndroidDeviceInfo androidDeviceInfo) {
    return DeviceDetailsReq(
        osType: "Android",
        deviceId: androidDeviceInfo.id,
        deviceDetails: AndroidDeviceDetails(
            versionCode: androidDeviceInfo.version.sdkInt,
            versionName: androidDeviceInfo.version.codename,
            baseOS: androidDeviceInfo.version.baseOS.toString(),
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
            serialNumber: androidDeviceInfo.serialNumber));
  }
}
