import 'package:intl/intl.dart';

class RemodelingPricing {
  static int? getPaintingEstimate(int? area, bool? scrapeOldPaint) {
    if (area == null || scrapeOldPaint == null) {
      return null;
    } else {
      if (scrapeOldPaint) {
        if (area < 500) {
          return 28000;
        }
        if (area < 600) {
          return 38000;
        }
        if (area < 700) {
          return 46000;
        }
        if (area < 800) {
          return 55000;
        }
      } else {
        if (area < 500) {
          return 16000;
        }
        if (area < 600) {
          return 19000;
        }
        if (area < 700) {
          return 22000;
        }
        if (area < 800) {
          return 26500;
        }
      }
    }
    return -1; // todo
  }

  // TODO
  static int? getWallCoveringsEstimate(int? area) {
    if (area == null) {
      return null;
    } else {
      return 100 * area;
    }
  }

  // TODO
  static int? getAcEstimate() {
    return 1;
  }
}

String formatPrice(int? price) {
  if (price == null) {
    return '\$-';
  } else {
    return NumberFormat.currency(
            locale: 'zh_HK', symbol: '\$', decimalDigits: 0)
        .format(price);
  }
}
