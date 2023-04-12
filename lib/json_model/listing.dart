import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listing.g.dart';

@JsonSerializable()
class Listing {
  int id;
  int propertyId;
  String title;
  Terms terms;

  Listing(
      {this.id = -1,
      required this.propertyId,
      required this.title,
      Terms? terms})
      : terms = terms ?? Terms(propertyId: propertyId);

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);
}

class ListingHelper {
  static Listing getFromId(int id) {
    //todo temporary solution
    return getSampleListing().firstWhere((listing) => listing.id == id);
  }
}
