// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) => Listing(
      id: json['id'] as int? ?? -1,
      propertyId: json['propertyId'] as int,
      title: json['title'] as String,
      terms: json['terms'] == null
          ? null
          : Terms.fromJson(json['terms'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'title': instance.title,
      'terms': instance.terms,
    };
