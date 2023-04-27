import 'package:flutter/cupertino.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';

class ListingInheritedData extends InheritedWidget {
  ListingInheritedData({
    Key? key,
    required this.property,
    required Widget child,
  })  : terms = Terms(propertyId: property.id),
        listing = Listing(propertyId: property.id, title: ''),
        super(key: key, child: child);

  final Property property;
  final Terms terms;
  final Listing listing;

  static ListingInheritedData? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ListingInheritedData>();

  @override
  bool updateShouldNotify(covariant ListingInheritedData oldWidget) {
    return false;
  }
}
