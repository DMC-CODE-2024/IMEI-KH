import 'package:device_info/device_info.dart';
import 'package:eirs/features/launcher/data/business_logic/launcher_state.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/repoistory/eirs_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'launcher_event.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  EirsRepository eirsRepository = EirsRepository();

  LauncherBloc(super.initialState);

  @override
  LauncherState get initialState {
    return LauncherInitialState();
  }

  @override
  Stream<LauncherState> mapEventToState(LauncherEvent event) async* {
    if (event is LauncherInitEvent) {
      yield LauncherLoadingState();
      try {
        AndroidDeviceInfo androidDeviceInfo = deviceInfo();
        DeviceDetailsReq deviceDetailsReq = DeviceDetailsReq(
            osType: "Android",
            deviceId: androidDeviceInfo.id,
            deviceDetails: AndroidDeviceDetails(
                versionName: androidDeviceInfo.version.codename,
                versionCode: androidDeviceInfo.version.sdkInt));
        DeviceDetailsRes deviceDetailsRes =
            await eirsRepository.deviceDetailsReq(deviceDetailsReq);
        yield LauncherLoadedState(deviceDetailsRes);
        print(deviceDetailsRes);
      } catch (e) {
        print("error msg ${e.toString()}");
        yield LauncherErrorState(Error());
      }
    }
  }

  deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo;
  }
}
