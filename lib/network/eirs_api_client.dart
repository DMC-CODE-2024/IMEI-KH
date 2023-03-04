import 'package:dio/dio.dart';
import 'package:eirs/features/imei_info/data/models/check_imei_req.dart';
import 'package:eirs/features/imei_info/data/models/check_imei_res.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:retrofit/http.dart';

import 'eirs_apis.dart';

part 'eirs_api_client.g.dart';

@RestApi(baseUrl: "http://159.223.159.153:9504/eirs/")
abstract class EirsApiClient {
  factory EirsApiClient(Dio dio, {String baseUrl}) = _EirsApiClient;

  @POST(EirsApis.deviceDetails)
  Future<DeviceDetailsRes> deviceDetailReq(
      @Body() DeviceDetailsReq deviceDetailsReq);

  @GET(EirsApis.test)
  Future<String> getUsers();

  @POST(EirsApis.checkImei)
  Future<CheckImeiRes> checkImei(CheckImeiReq checkImeiReq);
}
