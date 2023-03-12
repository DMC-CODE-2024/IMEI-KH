import 'package:eirs/features/history/data/business_logic/device_history_event.dart';
import 'package:eirs/features/history/data/business_logic/device_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repoistory/eirs_repository.dart';

class DeviceHistoryBloc extends Bloc<DeviceHistoryEvent, DeviceHistoryState> {
  EirsRepository eirsRepository = EirsRepository();

  DeviceHistoryBloc() : super(DeviceHistoryInitialState()) {
    on<DeviceHistoryInitEvent>(mapEventToState);
  }

  void mapEventToState(
      DeviceHistoryEvent event, Emitter<DeviceHistoryState> emit) async {
    emit(DeviceHistoryLoadingState());
    try {
      List<Map<String, dynamic>> deviceHistory =
          await eirsRepository.getDeviceHistory();
      if (deviceHistory.isEmpty) {
        return emit(DeviceHistoryErrorState("No Data"));
      }
      emit(DeviceHistoryLoadedState(deviceHistory));
    } catch (e) {
      emit(DeviceHistoryErrorState(e.toString()));
    }
  }
}
