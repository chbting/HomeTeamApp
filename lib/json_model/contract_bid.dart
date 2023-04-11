import 'package:hometeam_client/json_model/contract.dart';
import 'package:hometeam_client/json_model/tenant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contract_bid.g.dart';

@JsonSerializable()
class ContractBid {
  int listingId;
  Contract bid = Contract(propertyId: propertyId);
  Tenant tenant = Tenant();
  String notes;

  ContractBid({required this.listingId, this.notes = ''});

  factory ContractBid.fromJson(Map<String, dynamic> json) =>
      _$ContractBidFromJson(json);

  Map<String, dynamic> toJson() => _$ContractBidToJson(this);
}
