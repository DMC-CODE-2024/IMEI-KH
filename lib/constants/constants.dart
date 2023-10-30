const Duration splashDuration = Duration(seconds: 2);
const Duration animationDuration = Duration(milliseconds: 400);
const Duration apiCallInterval = Duration(seconds: 5);
const int pageRefresh = 0;
const int checkImeiReq = 1;
const int languageReq = 2;
const int checkMultiImeiReq = 3;

const int preInitReqCode = 1;
const int initReqCode = 2;
const int requestTimeOut = 5 * 1000;
const String defaultUrl = "https://appapi.eirs.gov.kh";
String baseUrl = defaultUrl;
const String invalidStatusColor = "#eb5757";
const String validStatusColor = "#00D100";
const String channel = "app";
const privacyPolicyUrl = "https://www.eirs.gov.kh/privacy-policy/";
