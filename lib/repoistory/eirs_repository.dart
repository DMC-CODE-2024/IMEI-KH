import 'package:dio/dio.dart';
import 'package:eirs/features/imei_info/data/models/check_imei_req.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/network/eirs_api_client.dart';

class EirsRepository {
  static final EirsRepository _singletonUserRepository =
      EirsRepository._internal();

  factory EirsRepository() {
    return _singletonUserRepository;
  }

  EirsRepository._internal();

  // Save device details
  Future<dynamic> deviceDetailsReq(DeviceDetailsReq deviceDetailsReq) async {
    return await EirsApiClient(Dio()).deviceDetailReq(deviceDetailsReq);
  }

  // check imei
  Future<dynamic> checkImei(CheckImeiReq checkImeiReq) async{
    return await EirsApiClient(Dio()).checkImei(checkImeiReq);
  }

  Future<dynamic> getUserDetails() async {
    return await EirsApiClient(Dio()).getUsers();
  }
}
