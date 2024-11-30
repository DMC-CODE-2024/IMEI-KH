class Validator {
  //Validate scanned IMEI is numeric or not
  static bool isNumeric(String str) {
    return double.tryParse(str) != null && str.length == 15;
  }
}
