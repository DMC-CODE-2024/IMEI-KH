// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eirs_api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _EirsApiClient implements EirsApiClient {
  _EirsApiClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://159.223.159.153:9504/eirs/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<DeviceDetailsRes> deviceDetailReq(deviceDetailsReq) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(deviceDetailsReq.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DeviceDetailsRes>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'MobileDeviceDetails/save',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DeviceDetailsRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DeviceDetailsRes> languageRetriever(
    featureName,
    language,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DeviceDetailsRes>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'dialectRetreiver/${featureName}/${language}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DeviceDetailsRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckImeiRes> checkImei(
    checkImeiReq, {
    contentType = 'application/json',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': contentType};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(checkImeiReq.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CheckImeiRes>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              'services/checkIMEI',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CheckImeiRes.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
