import 'package:hometeam_client/json_model/contract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listing.g.dart';

@JsonSerializable()
class Listing {
  int id;
  String title; //todo?
  int propertyId;

  bool rentNegotiable;
  bool depositNegotiable;
  bool startDateNegotiable;
  bool endDateNegotiable;

  bool freePeriodNegotiable;
  bool freePeriodHidden;
  
  Contract contract;

  Listing(
      {this.id = -1,
      required this.title,
      required this.propertyId,
      required this.contract});

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);
}
