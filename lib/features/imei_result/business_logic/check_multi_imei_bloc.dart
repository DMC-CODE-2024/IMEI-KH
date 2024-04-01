import 'dart:io';

import 'package:eirs/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_ip_address/public_ip_address.dart';

import '../../../constants/enums.dart';
import '../../../constants/strings.dart';
import '../../../helper/shared_pref.dart';
import '../../../repoistory/eirs_repository.dart';
import '../../check_imei/data/models/check_country_ip_req.dart';
import '../../check_imei/data/models/check_country_ip_res.dart';
import '../../check_imei/data/models/check_imei_req.dart';
import '../../check_imei/data/models/check_imei_res.dart';
import '../data/models/multi_imei_res.dart';
import 'check_multi_imei_state.dart';

class CheckMultiImeiBloc extends Cubit<CheckMultiImeiState> {
  EirsRepository eirsRepository = EirsRepository();
  List<MultiImeiRes> imeiResponseList = [];
  bool isValidImei = false;

  CheckMultiImeiBloc() : super(CheckMultiImeiInitialState());

  checkMultiIMEIReq(String? languageType, List<String>? imeiMap) async {
    emit(CheckMultiImeiLoadingState());
    if (imeiResponseList.isNotEmpty) {
      imeiResponseList.clear();
    }
    List<String>? imeiList = imeiMap;
    if (imeiList == null || imeiList.isEmpty) {
      emit(CheckMultiImeiErrorState(StringConstants.emptyImeiError));
    } else {
      String? deviceId = await getDeviceId();
      String osType =
          (Platform.isIOS) ? StringConstants.iOSOs : StringConstants.androidOs;
      for (final imei in imeiList) {
        try {
          final inputImei = imei;
          CheckImeiReq checkImeiReq = CheckImeiReq(
              imei: inputImei,
              language: languageType ?? StringConstants.englishCode,
              channel: channel,
              deviceId: deviceId,
              osType: osType);
          CheckImeiRes checkImeiRes =
              await eirsRepository.checkImei(checkImeiReq);
          isValidImei = checkImeiRes.result?.validImei ?? false;
          eirsRepository.insertDeviceDetail(inputImei, checkImeiRes);
          imeiResponseList
              .add(MultiImeiRes(imei: inputImei, checkImeiRes: checkImeiRes));
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }
      if (imeiResponseList.isEmpty) {
        emit(CheckMultiImeiErrorState(StringConstants.errorInScanImei));
      } else {
        emit(CheckMultiImeiLoadedState(isValidImei, imeiResponseList));
      }
    }
  }

  pageRefresh() {
    emit(PageRefresh());
  }

  checkCountryIpReq() async {
    try {
      emit(MultiImeiIpLoadingState());
      String ip = await IpAddress.getIp(version: Ip.v4);
      CheckCountryIPRes checkCountryIPRes = await eirsRepository
          .checkCountryIP(CheckCountryIPReq(ip: ip, ipType: IPType.ipv4.value));
      emit(MultiImeiIpLoadedState(checkCountryIPRes));
    } catch (e) {
      emit(MultiImeiIpErrorState(e.toString()));
    }
  }
}
