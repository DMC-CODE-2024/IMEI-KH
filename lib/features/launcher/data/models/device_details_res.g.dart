// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_details_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDetailsRes _$DeviceDetailsResFromJson(Map<String, dynamic> json) =>
    DeviceDetailsRes()
      ..languageType = json['languageType'] as String?
      ..labelDetails = json['labelDetails'] == null
          ? null
          : LabelDetails.fromJson(json['labelDetails'] as Map<String, dynamic>);

Map<String, dynamic> _$DeviceDetailsResToJson(DeviceDetailsRes instance) =>
    <String, dynamic>{
      'languageType': instance.languageType,
      'labelDetails': instance.labelDetails,
    };

LabelDetails _$LabelDetailsFromJson(Map<String, dynamic> json) => LabelDetails()
  ..findImei = json['find_imei'] as String?
  ..getImeiInfo = json['get_imie_information'] as String?
  ..imeiDetails = json['imei_details'] as String?
  ..enterImei = json['enter_imei'] as String?
  ..optionA = json['option_a'] as String?
  ..aboutUs = json['aboutUs'] as String?
  ..makeSureWifiData = json['makeSureWifiData'] as String?
  ..checkImeiMesssage = json['checkImeiMesssage'] as String?
  ..imeiAlsoWrittenInBox =
      json['IMEI_also_written_in_the_box_as_shown_in_Image_below'] as String?
  ..imeiAlsoWritten = json['imeiAlsoWritten'] as String?
  ..scan = json['scan'] as String?
  ..enterFifteenDigit = json['enter15Digit'] as String?
  ..changeAppLanguage = json['changeAppLanguage'] as String?
  ..eirsApp = json['eirs_app'] as String?
  ..remark = json['remark'] as String?
  ..emailId = json['emailId'] as String?
  ..language = json['language'] as String?
  ..selectOneImei = json['selectOneImei '] as String?
  ..selectOnImei = json['selectOnImei'] as String?
  ..callToAction = json['callToAction'] as String?
  ..sorryUnableToFetch = json['sorryUnableToFetch'] as String?
  ..getList = json['getList'] as String?
  ..oops = json['oops'] as String?
  ..ok = json['ok'] as String?
  ..findImeiLabel = json['findImei'] as String?
  ..dial = json['dial'] as String?
  ..contactUs = json['contactUs'] as String?
  ..or = json['or'] as String?
  ..scanIMEI = json['scanIMEI'] as String?
  ..clickToWatch = json['clickToWatch'] as String?
  ..changeLanguage = json['changeLanguage'] as String?
  ..knowMore = json['knowMore'] as String?
  ..tryAgain = json['tryAgain'] as String?
  ..noInternetConnection = json['noInternetConnection'] as String?
  ..optionALabel = json['optionA'] as String?
  ..history = json['history'] as String?
  ..optionB = json['optionB'] as String?
  ..checkIMEI = json['checkIMEI'] as String?
  ..scanBar = json['scanBar'] as String?
  ..eirsAppHeader = json['eirsAppHeader'] as String?
  ..enterIMEI = json['enterIMEI'] as String?
  ..canBeBarcode = json['canBeBarcode'] as String?
  ..getIMEIInfo = json['getIMEIInfo'] as String?
  ..invalid = json['invalid'] as String?
  ..checkOtherImei = json['checkOtherImei'] as String?
  ..needAnyHelp = json['needAnyHelp'] as String?
  ..result = json['Result'] as String?
  ..check = json['check'] as String?
  ..khmer = json['khmer'] as String?
  ..imeiInfo = json['imeiInfo'] as String?
  ..feildNotEmpty = json['feildNotEmpty'] as String?
  ..noImeiSelected = json['noImeiSelected'] as String?
  ..copyRight = json['copyRight'] as String?
  ..imeiNotPer3gpp = json['imeiNotPer3gpp'] as String?
  ..scanCode = json['scanCode'] as String?
  ..min15Digit = json['min15Digit'] as String?;

Map<String, dynamic> _$LabelDetailsToJson(LabelDetails instance) =>
    <String, dynamic>{
      'find_imei': instance.findImei,
      'get_imie_information': instance.getImeiInfo,
      'imei_details': instance.imeiDetails,
      'enter_imei': instance.enterImei,
      'option_a': instance.optionA,
      'aboutUs': instance.aboutUs,
      'makeSureWifiData': instance.makeSureWifiData,
      'checkImeiMesssage': instance.checkImeiMesssage,
      'IMEI_also_written_in_the_box_as_shown_in_Image_below':
          instance.imeiAlsoWrittenInBox,
      'imeiAlsoWritten': instance.imeiAlsoWritten,
      'scan': instance.scan,
      'enter15Digit': instance.enterFifteenDigit,
      'changeAppLanguage': instance.changeAppLanguage,
      'eirs_app': instance.eirsApp,
      'remark': instance.remark,
      'emailId': instance.emailId,
      'language': instance.language,
      'selectOneImei ': instance.selectOneImei,
      'selectOnImei': instance.selectOnImei,
      'callToAction': instance.callToAction,
      'sorryUnableToFetch': instance.sorryUnableToFetch,
      'getList': instance.getList,
      'oops': instance.oops,
      'ok': instance.ok,
      'findImei': instance.findImeiLabel,
      'dial': instance.dial,
      'contactUs': instance.contactUs,
      'or': instance.or,
      'scanIMEI': instance.scanIMEI,
      'clickToWatch': instance.clickToWatch,
      'changeLanguage': instance.changeLanguage,
      'knowMore': instance.knowMore,
      'tryAgain': instance.tryAgain,
      'noInternetConnection': instance.noInternetConnection,
      'optionA': instance.optionALabel,
      'history': instance.history,
      'optionB': instance.optionB,
      'checkIMEI': instance.checkIMEI,
      'scanBar': instance.scanBar,
      'eirsAppHeader': instance.eirsAppHeader,
      'enterIMEI': instance.enterIMEI,
      'canBeBarcode': instance.canBeBarcode,
      'getIMEIInfo': instance.getIMEIInfo,
      'invalid': instance.invalid,
      'checkOtherImei': instance.checkOtherImei,
      'needAnyHelp': instance.needAnyHelp,
      'Result': instance.result,
      'check': instance.check,
      'khmer': instance.khmer,
      'imeiInfo': instance.imeiInfo,
      'feildNotEmpty': instance.feildNotEmpty,
      'noImeiSelected': instance.noImeiSelected,
      'copyRight': instance.copyRight,
      'imeiNotPer3gpp': instance.imeiNotPer3gpp,
      'scanCode': instance.scanCode,
      'min15Digit': instance.min15Digit,
    };
