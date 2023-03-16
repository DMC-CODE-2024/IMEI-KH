import 'package:eirs/features/check_multi_imei/data/models/multi_imei_res.dart';
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
      emit(CheckMultiImeiLoadingState());
      try {
        if (imeiResponseList.isNotEmpty) {
          imeiResponseList.clear();
        }
        for (final mapEntry in event.imeiMap.entries) {
          final key = mapEntry.key;
          CheckImeiReq checkImeiReq = CheckImeiReq(
              imei: key ?? "",
              operator: "smart",
              language: event.languageType ?? StringConstants.englishCode,
              channel: "phone");
          CheckImeiRes checkImeiRes =
              await eirsRepository.checkImei(checkImeiReq);
          eirsRepository.insertDeviceDetail(key ?? "", checkImeiRes);
          imeiResponseList
              .add(MultiImeiRes(imei: key, checkImeiRes: checkImeiRes));
        }
        emit(CheckMultiImeiLoadedState(imeiResponseList));
      } catch (e) {
        emit(CheckMultiImeiErrorState(e.toString()));
      }
    }
  }
}
