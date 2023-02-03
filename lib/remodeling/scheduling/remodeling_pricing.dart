import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/remodeling_types.dart';

class RemodelingPricing {
  static int getEstimate(RemodelingItem item) {
    switch (item.type) {
      case RemodelingType.painting:
        item as RemodelingPainting;
        return _getPaintingEstimate(item.paintArea, item.scrapeOldPaint);
      case RemodelingType.wallCoverings:
        item as RemodelingWallCoverings;
        return _getWallCoveringsEstimate(item.area);
      case RemodelingType.ac:
        return _getAcEstimate();
      case RemodelingType.removals:
        return -1;
      case RemodelingType.suspendedCeiling:
        return -1;
      case RemodelingType.toiletReplacement:
        return -1;
      case RemodelingType.pestControl:
        return -1;
    }
  }

  static int _getPaintingEstimate(int area, bool scrapeOldPaint) {
    if (area == 0) {
      return 0;
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
    return -1; // todo for area = 800+
  }

  static int _getWallCoveringsEstimate(int area) {
    if (area == 0) {
      return 0; //todo check
    } else {
      return 100 * area; //TODO correct pricing
    }
  }

  // TODO
  static int _getAcEstimate() {
    return -1;
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
