import 'package:eirs/features/check_multi_imei/data/models/multi_imei_res.dart';

abstract class CheckMultiImeiState {}

class CheckMultiImeiInitialState extends CheckMultiImeiState {}

class CheckMultiImeiLoadingState extends CheckMultiImeiState {}

class CheckMultiImeiLoadedState extends CheckMultiImeiState {
  List<MultiImeiRes> multiImeiResList;

  CheckMultiImeiLoadedState(this.multiImeiResList);
}

class CheckMultiImeiErrorState extends CheckMultiImeiState {
  String e;

  CheckMultiImeiErrorState(this.e);
}
