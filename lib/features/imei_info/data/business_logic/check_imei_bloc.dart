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

  void mapEventToState(CheckImeiEvent event, Emitter<CheckImeiState> emit) async {
    emit(CheckImeiLoadingState());
    if (event is CheckImeiInitEvent) {
      try {
        print("yes here");
        CheckImeiReq checkImeiReq = CheckImeiReq(imei: event.inputImei, operator: "smart", language: "en",channel: "string");
        print(checkImeiReq.toJson());
        CheckImeiRes checkImeiRes = await eirsRepository.checkImei(checkImeiReq);
        emit(CheckImeiLoadedState(checkImeiRes));
      } catch (e) {
        print("Error: ${e.toString()}");
        emit(CheckImeiErrorState(e.toString()));
      }
    }
  }
}
