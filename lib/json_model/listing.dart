import 'package:hometeam_client/json_model/terms.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listing.g.dart';

@JsonSerializable()
class Listing {
  int id;
  int propertyId;
  String title;
  Terms? terms;

  Listing(
      {this.id = -1,
      required this.propertyId,
      required this.title,
      required this.terms});

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);
}
