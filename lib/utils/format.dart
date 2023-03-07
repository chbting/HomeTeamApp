import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hometeam_client/generated/l10n.dart';

class Format {
  /// The long format requires the use of locale
  static String dateLong = 'd/M/y (EEEE)';
  static String date = 'd/M/y';
  static NumberFormat currency =
      NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  static String formatDuration(Duration duration, BuildContext context) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    String hourStr = hours == 0
        ? ''
        : hours == 1
            ? '1 ${S.of(context).hour}'
            : '$hours ${S.of(context).hours}';

    String minStr = minutes == 0
        ? ''
        : minutes == 1
            ? '1 ${S.of(context).minute}'
            : '$minutes ${S.of(context).minutes}';

    return '$hourStr $minStr';
  }
}
