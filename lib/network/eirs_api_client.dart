import 'package:dio/dio.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:retrofit/http.dart';
import 'eirs_apis.dart';
part 'eirs_api_client.g.dart';

@RestApi(baseUrl: "https://eirs.gov.kh/services/checkIMEI/")
abstract class EirsApiClient {
  factory EirsApiClient(Dio dio, {String baseUrl}) = _EirsApiClient;

  @GET(EirsApis.deviceDetails)
  Future<DeviceDetailsRes> deviceDetailReq(DeviceDetailsReq deviceDetailsReq);
}