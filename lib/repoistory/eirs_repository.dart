import 'package:dio/dio.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/network/eirs_api_client.dart';

class EirsRepository {
  static final EirsRepository _singletonUserRepository =
      EirsRepository._internal();

  factory EirsRepository() {
    return _singletonUserRepository;
  }

  EirsRepository._internal();

  Future<dynamic> deviceDetailsReq(DeviceDetailsReq deviceDetailsReq) async {
    return await EirsApiClient(Dio()).deviceDetailReq(deviceDetailsReq);
  }

  Future<dynamic> getUserDetails() async {
    return await EirsApiClient(Dio()).getUsers();
  }
}
