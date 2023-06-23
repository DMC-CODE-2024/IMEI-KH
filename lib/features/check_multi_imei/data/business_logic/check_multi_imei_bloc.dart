import 'package:eirs/constants/constants.dart';
import 'package:eirs/features/check_multi_imei/data/models/multi_imei_res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/strings.dart';
import '../../../../repoistory/eirs_repository.dart';
import '../../../check_imei/data/models/check_imei_req.dart';
import '../../../check_imei/data/models/check_imei_res.dart';
import 'check_multi_imei_event.dart';
import 'check_multi_imei_state.dart';

class CheckMultiImeiBloc
    extends Bloc<CheckMultiImeiEvent, CheckMultiImeiState> {
  EirsRepository eirsRepository = EirsRepository();
  List<MultiImeiRes> imeiResponseList = [];

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
          Map<String, int>? imeiMap = event.imeiMap;
          if (imeiMap == null || imeiMap.isEmpty) {
            emit(CheckMultiImeiErrorState(StringConstants.emptyImeiError));
          } else {
            for (final mapEntry in imeiMap.entries) {
              try {
                final key = mapEntry.key;
                CheckImeiReq checkImeiReq = CheckImeiReq(
                    imei: key,
                    language: event.languageType ?? StringConstants.englishCode,
                    channel: "phone");
                CheckImeiRes checkImeiRes =
                    await eirsRepository.checkImei(checkImeiReq);
                eirsRepository.insertDeviceDetail(key, checkImeiRes);
                imeiResponseList
                    .add(MultiImeiRes(imei: key, checkImeiRes: checkImeiRes));
              } catch (e) {
                if (kDebugMode) {
                  print(e.toString());
                }
              }
            }
            if (imeiResponseList.isEmpty) {
              emit(CheckMultiImeiErrorState(StringConstants.errorInScanImei));
            } else {
              emit(CheckMultiImeiLoadedState(imeiResponseList));
            }
          }
          break;
      }
    }
  }
}
