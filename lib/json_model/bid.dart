import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/tenant.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bid.g.dart';

@JsonSerializable()
class Bid {
  String listingId;
  Tenant tenant;
  Terms biddingTerms;
  String notes;

  @JsonKey(includeFromJson: true, includeToJson: false)
  Terms originalTerms;

  Bid({required this.listingId, required this.biddingTerms, this.notes = ''})
      : tenant = Tenant(),
        originalTerms = ListingHelper.getFromId(listingId).terms;

  factory Bid.fromJson(Map<String, dynamic> json) => _$BidFromJson(json);

  Map<String, dynamic> toJson() => _$BidToJson(this);
}
