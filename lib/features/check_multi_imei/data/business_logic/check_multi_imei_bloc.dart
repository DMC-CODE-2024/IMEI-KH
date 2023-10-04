import 'dart:io';

import 'package:eirs/constants/constants.dart';
import 'package:eirs/features/check_multi_imei/data/models/multi_imei_res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/strings.dart';
import '../../../../helper/shared_pref.dart';
import '../../../../repoistory/eirs_repository.dart';
import '../../../check_imei/data/models/check_imei_req.dart';
import '../../../check_imei/data/models/check_imei_res.dart';
import 'check_multi_imei_event.dart';
import 'check_multi_imei_state.dart';

class CheckMultiImeiBloc
    extends Bloc<CheckMultiImeiEvent, CheckMultiImeiState> {
  EirsRepository eirsRepository = EirsRepository();
  List<MultiImeiRes> imeiResponseList = [];
  bool isValidImei = false;

  CheckMultiImeiBloc() : super(CheckMultiImeiInitialState()) {
    on<CheckMultiImeiInitEvent>(mapEventToState);
  }

  void mapEventToState(
      CheckMultiImeiEvent event, Emitter<CheckMultiImeiState> emit) async {
    if (event is CheckMultiImeiInitEvent) {
      switch (event.requestCode) {
        case pageRefresh:
          emit(PageRefresh());
          break;
        case checkMultiImeiReq:
          emit(CheckMultiImeiLoadingState());
          if (imeiResponseList.isNotEmpty) {
            imeiResponseList.clear();
          }
          List<String>? imeiList = event.imeiMap;
          if (imeiList == null || imeiList.isEmpty) {
            emit(CheckMultiImeiErrorState(StringConstants.emptyImeiError));
          } else {
            String? deviceId = await getDeviceId();
            String osType = (Platform.isIOS)
                ? StringConstants.iOSOs
                : StringConstants.androidOs;
            for (final imei in imeiList) {
              try {
                final inputImei = imei;
                CheckImeiReq checkImeiReq = CheckImeiReq(
                    imei: inputImei,
                    language: event.languageType ?? StringConstants.englishCode,
                    channel: channel,
                    deviceId: deviceId,
                    osType: osType);
                CheckImeiRes checkImeiRes =
                    await eirsRepository.checkImei(checkImeiReq);
                isValidImei = checkImeiRes.result?.validImei ?? false;
                eirsRepository.insertDeviceDetail(inputImei, checkImeiRes);
                imeiResponseList.add(
                    MultiImeiRes(imei: inputImei, checkImeiRes: checkImeiRes));
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
          break;
      }
    }
  }
}
