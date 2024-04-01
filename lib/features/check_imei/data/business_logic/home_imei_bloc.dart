import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/strings.dart';
import '../../../../helper/shared_pref.dart';
import '../../../../repoistory/eirs_repository.dart';
import '../../../launcher/data/models/device_details_res.dart';
import '../models/check_imei_req.dart';
import '../models/check_imei_res.dart';
import 'check_imei_state.dart';

class HomeImeiBloc extends Cubit<CheckImeiState> {
  EirsRepository eirsRepository = EirsRepository();

  HomeImeiBloc() : super(CheckImeiInitialState());

  checkImeiReq(String? inputImei, String? languageType, String channel) async {
    try {
      emit(CheckImeiLoadingState());
      String? deviceId = await getDeviceId();
      String osType =
          (Platform.isIOS) ? StringConstants.iOSOs : StringConstants.androidOs;
      CheckImeiReq checkImeiReq = CheckImeiReq(
          imei: inputImei ?? "",
          language: languageType ?? StringConstants.englishCode,
          channel: channel,
          deviceId: deviceId,
          osType: osType);
      CheckImeiRes checkImeiRes = await eirsRepository.checkImei(checkImeiReq);
      eirsRepository.insertDeviceDetail(inputImei ?? "", checkImeiRes);
      emit(CheckImeiLoadedState(checkImeiRes));
    } catch (e) {
      emit(CheckImeiErrorState(e.toString()));
    }
  }

  changeLanguageReq(String? languageType) async {
    try {
      emit(LanguageLoadingState());
      DeviceDetailsRes deviceDetailsRes = await eirsRepository.getLanguage(
          "CheckImei", languageType ?? StringConstants.englishCode);
      setLocale(deviceDetailsRes.languageType ?? StringConstants.englishCode);
      emit(LanguageLoadedState(deviceDetailsRes));
    } catch (e) {
      emit(LanguageErrorState(e.toString()));
    }
  }

  pageRefresh() {
    emit(CheckImeiPageRefresh());
  }
}
