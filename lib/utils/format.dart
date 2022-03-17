import 'package:intl/intl.dart';

class Format {
  /// The long format requires the use of locale
  static String dateLong = 'd/M/y (EEEE)';
  static String date = 'd/M/y';
  static NumberFormat currency =
      NumberFormat.currency(symbol: '\$', decimalDigits: 0);
}
