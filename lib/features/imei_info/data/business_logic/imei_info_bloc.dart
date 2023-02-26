import 'package:bloc/bloc.dart';

import 'imei_info_state.dart';

part 'imei_info_event.dart';

class ImeiInfoBloc extends Bloc {
  // final _userRepository = UserRepository();

  ImeiInfoBloc() : super(ImeiInfoInitial()) {
    on<ImeiInfoRequest>;
  }

  void mapToEventState(
      ImeiInfoRequest event, Emitter<ImeiInfoState> emit) async {
    emit(ImeiInfoLoadingProgress());
  }
}
