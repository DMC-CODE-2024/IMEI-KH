import 'package:dio/dio.dart';
import 'package:eirs/features/launcher/data/models/device_details_req.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/features/launcher/data/models/pre_init_res.dart';
import 'package:retrofit/http.dart';

import '../features/check_imei/data/models/check_imei_req.dart';
import '../features/check_imei/data/models/check_imei_res.dart';
import 'eirs_apis.dart';

part 'eirs_api_client.g.dart';

@RestApi(baseUrl: "http://159.223.159.153:9504/eirs/")
abstract class EirsApiClient {
  factory EirsApiClient(Dio dio, {String baseUrl}) = _EirsApiClient;

  @POST(EirsApis.deviceDetails)
  Future<DeviceDetailsRes> deviceDetailReq(
      @Body() DeviceDetailsReq deviceDetailsReq);

  @GET(EirsApis.languageRetriever)
  Future<DeviceDetailsRes> languageRetriever(@Query("feature_name") String featureName,@Query("language") String language);

  @POST(EirsApis.checkImei)
  Future<CheckImeiRes> checkImei(@Body() CheckImeiReq checkImeiReq,
      {@Header('Content-Type') String contentType = 'application/json'});

  @GET(EirsApis.preInit)
  Future<PreInitRes> preInit(@Query("deviceId") String deviceId);

}
