const Duration splashDuration = Duration(seconds: 2);
const Duration animationDuration = Duration(milliseconds: 400);
const Duration apiCallInterval = Duration(seconds: 5);
const int pageRefresh = 0;
const int checkImeiReq = 1;
const int languageReq = 2;
const int checkMultiImeiReq = 3;

const int preInitReqCode = 1;
const int initReqCode = 2;
//String defaultUrl = "http://159.223.159.153:9504";
String defaultUrl = "https://lab.api.eirs.gov.kh";
String baseUrl = defaultUrl;
const String invalidStatusColor = "#eb5757";
const String validStatusColor = "#00D100";