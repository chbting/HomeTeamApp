class FirebasePath {
  static const String properties = "properties";
  static const String listings = "listings";

  static String getPropertyImagesPath(String propertyId) =>
      "images/properties/$propertyId";
}
