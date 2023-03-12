import 'package:json_annotation/json_annotation.dart';

part 'device_details_res.g.dart';

@JsonSerializable()
class DeviceDetailsRes {
  String? languageType;
  LabelDetails? labelDetails;

  DeviceDetailsRes();

  factory DeviceDetailsRes.fromJson(Map<String, dynamic> json) =>
      _$DeviceDetailsResFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDetailsResToJson(this);
}

@JsonSerializable()
class LabelDetails {
  @JsonKey(name: 'find_imei')
  String? findImei;
  @JsonKey(name: 'get_imie_information')
  String? getImeiInfo;
  @JsonKey(name: 'imei_details')
  String? imeiDetails;
  @JsonKey(name: 'enter_imei')
  String? enterImei;
  @JsonKey(name: 'option_a')
  String? optionA;
  String? aboutUs;
  String? makeSureWifiData;
  String? checkImeiMesssage;
  @JsonKey(name: 'IMEI_also_written_in_the_box_as_shown_in_Image_below')
  String? imeiAlsoWrittenInBox;
  String? imeiAlsoWritten;
  String? scan;
  @JsonKey(name: 'enter15Digit')
  String? enterFifteenDigit;
  String? changeAppLanguage;
  @JsonKey(name: 'eirs_app')
  String? eirsApp;
  String? remark;
  String? emailId;
  String? language;
  @JsonKey(name: 'selectOneImei ')
  String? selectOneImei;
  String? selectOnImei;
  String? callToAction;
  String? sorryUnableToFetch;
  String? getList;
  String? oops;
  String? ok;
  @JsonKey(name: 'findImei')
  String? findImeiLabel;
  String? dial;
  String? contactUs;
  String? or;
  String? scanIMEI;
  String? clickToWatch;
  String? changeLanguage;
  String? knowMore;
  String? tryAgain;
  String? noInternetConnection;
  @JsonKey(name: 'optionA')
  String? optionALabel;
  String? history;
  String? optionB;
  String? checkIMEI;
  String? scanBar;
  String? eirsAppHeader;
  String? enterIMEI;
  String? canBeBarcode;
  String? getIMEIInfo;
  String? invalid;
  String? checkOtherImei;
  String? needAnyHelp;
  @JsonKey(name: 'Result')
  String? result;
  String? check;
  String? khmer;
  String? imeiInfo;
  String? feildNotEmpty;
  String? noImeiSelected;
  String? copyRight;
  String? imeiNotPer3gpp;
  String? scanCode;
  String? min15Digit;
  LabelDetails();

  factory LabelDetails.fromJson(Map<String, dynamic> json) =>
      _$LabelDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$LabelDetailsToJson(this);
}
