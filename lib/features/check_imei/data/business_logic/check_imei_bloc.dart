import 'package:bloc/bloc.dart';
import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';

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
    if (event is CheckImeiInitEvent && event.inputImei != null) {
      emit(CheckImeiLoadingState());
      try {
        CheckImeiReq checkImeiReq = CheckImeiReq(
            imei: event.inputImei ?? "",
            operator: "smart",
            language: "en",
            channel: "phone");
        CheckImeiRes checkImeiRes =
            await eirsRepository.checkImei(checkImeiReq);
        eirsRepository.insertDeviceDetail(event.inputImei ?? "", checkImeiRes);
        emit(CheckImeiLoadedState(checkImeiRes));
      } catch (e) {
        emit(CheckImeiErrorState(e.toString()));
      }
    }

    if (event is CheckImeiInitEvent && event.languageType!=null) {
      print("yes here invoke");
      emit(LanguageLoadingState());
      try {
        DeviceDetailsRes deviceDetailsRes =
            await eirsRepository.getLanguage("CheckImei", event.languageType ?? StringConstants.englishCode);
        print("${deviceDetailsRes.toJson()}");
        emit(LanguageLoadedState(deviceDetailsRes));
      } catch (e) {
        print("${e.toString()}");
        emit(LanguageErrorState(e.toString()));
      }
    }
  }
}
