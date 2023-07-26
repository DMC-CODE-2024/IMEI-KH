import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/helper/shared_pref.dart';

import '../../../../constants/constants.dart';
import '../../../../repoistory/eirs_repository.dart';
import '../models/check_imei_req.dart';
import '../models/check_imei_res.dart';
import 'check_imei_state.dart';

part 'check_imei_event.dart';

class CheckImeiBloc extends Bloc<CheckImeiEvent, CheckImeiState> {
  EirsRepository eirsRepository = EirsRepository();

  CheckImeiBloc() : super(CheckImeiInitialState()) {
    on<CheckImeiInitEvent>(mapEventToState);
  }

  void mapEventToState(
      CheckImeiEvent event, Emitter<CheckImeiState> emit) async {
    if (event is CheckImeiInitEvent) {
      switch (event.requestCode) {
        case pageRefresh:
          emit(CheckImeiPageRefresh());
          break;
        case checkImeiReq:
          emit(CheckImeiLoadingState());
          try {
            String? deviceId = await getDeviceId();
            String osType = (Platform.isIOS)
                ? StringConstants.iOSOs
                : StringConstants.androidOs;

            CheckImeiReq checkImeiReq = CheckImeiReq(
                imei: event.inputImei ?? "",
                language: event.languageType ?? StringConstants.englishCode,
                channel: "phone",deviceId: deviceId,osType: osType);
            print("Check IMEI Req: ${checkImeiReq.toJson()}");
            CheckImeiRes checkImeiRes =
                await eirsRepository.checkImei(checkImeiReq);
            eirsRepository.insertDeviceDetail(
                event.inputImei ?? "", checkImeiRes);
            emit(CheckImeiLoadedState(checkImeiRes));
          } catch (e) {
            emit(CheckImeiErrorState(e.toString()));
          }
          break;
        case languageReq:
          emit(LanguageLoadingState());
          try {
            DeviceDetailsRes deviceDetailsRes =
                await eirsRepository.getLanguage("CheckImei",
                    event.languageType ?? StringConstants.englishCode);
            setLocale(
                deviceDetailsRes.languageType ?? StringConstants.englishCode);
            emit(LanguageLoadedState(deviceDetailsRes));
          } catch (e) {
            emit(LanguageErrorState(e.toString()));
          }
          break;
      }
    }
  }
}
