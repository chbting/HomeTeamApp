// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bid _$BidFromJson(Map<String, dynamic> json) => Bid(
      listingId: json['listingId'] as int,
      biddingTerms:
          Terms.fromJson(json['biddingTerms'] as Map<String, dynamic>),
      notes: json['notes'] as String? ?? '',
    )..tenant = Tenant.fromJson(json['tenant'] as Map<String, dynamic>);

Map<String, dynamic> _$BidToJson(Bid instance) => <String, dynamic>{
      'listingId': instance.listingId,
      'tenant': instance.tenant,
      'biddingTerms': instance.biddingTerms,
      'notes': instance.notes,
    };
