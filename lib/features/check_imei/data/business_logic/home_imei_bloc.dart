import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/strings.dart';
import '../../../../helper/shared_pref.dart';
import '../../../../repoistory/eirs_repository.dart';
import '../../../launcher/data/models/device_details_res.dart';
import 'check_imei_state.dart';

class HomeImeiBloc extends Cubit<CheckImeiState> {
  EirsRepository eirsRepository = EirsRepository();

  HomeImeiBloc() : super(CheckImeiInitialState());

  //Network call for updating label details based on input language
  changeLanguageReq(String? languageType) async {
    try {
      emit(LanguageLoadingState());
      DeviceDetailsRes deviceDetailsRes = await eirsRepository.getLanguage(
          "CheckImei", languageType ?? StringConstants.englishCode);
      setLocale(deviceDetailsRes.languageType ?? StringConstants.englishCode);
      deviceDetailsRes.labelDetails?.featureMenu = deviceDetailsRes.featureMenu;
      emit(LanguageLoadedState(deviceDetailsRes));
    } catch (e) {
      emit(LanguageErrorState(e.toString()));
    }
  }

  pageRefresh() {
    emit(CheckImeiPageRefresh());
  }
}
