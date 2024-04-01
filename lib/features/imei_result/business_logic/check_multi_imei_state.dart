
import '../../check_imei/data/models/check_country_ip_res.dart';
import '../data/models/multi_imei_res.dart';

abstract class CheckMultiImeiState {}

class CheckMultiImeiInitialState extends CheckMultiImeiState {}

class CheckMultiImeiLoadingState extends CheckMultiImeiState {}

class PageRefresh extends CheckMultiImeiState {}

class CheckMultiImeiLoadedState extends CheckMultiImeiState {
  List<MultiImeiRes> multiImeiResList;
  bool isValidImei;

  CheckMultiImeiLoadedState(this.isValidImei, this.multiImeiResList);
}

class CheckMultiImeiErrorState extends CheckMultiImeiState {
  String e;

  CheckMultiImeiErrorState(this.e);
}


//Check country IP req
class MultiImeiIpLoadingState extends CheckMultiImeiState {}

class MultiImeiIpErrorState extends CheckMultiImeiState {
  String e;

  MultiImeiIpErrorState(this.e);
}

class MultiImeiIpLoadedState extends CheckMultiImeiState {
  CheckCountryIPRes checkCountryIPRes;

  MultiImeiIpLoadedState(this.checkCountryIPRes);
}