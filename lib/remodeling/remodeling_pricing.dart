class RemodelingPricing {
  
  static int getPaintingEstimate(int paintArea, bool scrapeOldPaint) {
      if (scrapeOldPaint) {
        if (paintArea < 500) {
          return 28000;
        }
        if (paintArea < 600) {
          return 38000;
        }
        if (paintArea < 700) {
          return 46000;
        }
        if (paintArea < 800) {
          return 55000;
        }
      } else {
        if (paintArea < 500) {
          return 16000;
        }
        if (paintArea < 600) {
          return 19000;
        }
        if (paintArea < 700) {
          return 22000;
        }
        if (paintArea < 800) {
          return 26500;
        }
      }
      return -1; // todo
  }
}