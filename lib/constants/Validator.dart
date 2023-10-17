class Validator {
  static bool isValidIMEI(double n) {
    var s = n.toString();
    var len = s.length;
    var sum = 0;
    for (var i = len; i >= 1; i--) {
      var d = (n % 10).toInt();
      if (i % 2 == 0) {
        d = 2 * d;
      }
      sum += sumDig(d);
      n = n / 10;
    }
    return (sum % 10 == 0);
  }

  static int sumDig(int n) {
    var a = 0;
    while (n > 0) {
      a = a + n % 10;
      n = n ~/ 10;
    }
    return a;
  }

  static bool isNumeric(String str) {
    return double.tryParse(str) != null && str.length == 15;
  }
}
