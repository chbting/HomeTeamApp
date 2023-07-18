import 'package:flutter/cupertino.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';

class PropertyUploaderInheritedData extends InheritedWidget {
  PropertyUploaderInheritedData({
    Key? key,
    required this.property,
    required Widget child,
  })  : terms = Terms(propertyId: ''),
        listing = Listing(propertyId: '', title: ''),
        super(key: key, child: child);

  PropertyUploaderInheritedData.debug({
    Key? key,
    required this.property,
    required Widget child,
  })  : terms = Debug.getSampleTerms(),
        listing = Listing(propertyId: '', title: ''),
        super(key: key, child: child);

  final Property property;
  final Terms terms;
  final Listing listing;

  static PropertyUploaderInheritedData? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<PropertyUploaderInheritedData>();

  @override
  bool updateShouldNotify(covariant PropertyUploaderInheritedData oldWidget) {
    return false;
  }
}
