import 'package:bloc/bloc.dart';
import 'package:eirs/features/imei_info/data/models/check_imei_req.dart';
import 'package:eirs/features/imei_info/data/models/check_imei_res.dart';

import '../../../../repoistory/eirs_repository.dart';
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
        emit(CheckImeiLoadedState(checkImeiRes));
      } catch (e) {
        emit(CheckImeiErrorState(e.toString()));
      }
    }
  }
}
