// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_matrix.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistanceMatrix _$DistanceMatrixFromJson(Map<String, dynamic> json) =>
    DistanceMatrix(
      (json['destination_addresses'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['origin_addresses'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['rows'] as List<dynamic>)
          .map(
              (e) => DistanceMatrixElements.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['status'] as String,
    );

Map<String, dynamic> _$DistanceMatrixToJson(DistanceMatrix instance) =>
    <String, dynamic>{
      'destination_addresses': instance.destination_addresses,
      'origin_addresses': instance.origin_addresses,
      'rows': instance.rows,
      'status': instance.status,
    };

DistanceMatrixElements _$DistanceMatrixElementsFromJson(
        Map<String, dynamic> json) =>
    DistanceMatrixElements(
      (json['elements'] as List<dynamic>)
          .map((e) => DistanceMatrixElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DistanceMatrixElementsToJson(
        DistanceMatrixElements instance) =>
    <String, dynamic>{
      'elements': instance.elements,
    };

DistanceMatrixElement _$DistanceMatrixElementFromJson(
        Map<String, dynamic> json) =>
    DistanceMatrixElement(
      TravelDistance.fromJson(json['distance'] as Map<String, dynamic>),
      TravelDuration.fromJson(json['duration'] as Map<String, dynamic>),
      json['status'] as String,
    );

Map<String, dynamic> _$DistanceMatrixElementToJson(
        DistanceMatrixElement instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'status': instance.status,
    };

TravelDistance _$TravelDistanceFromJson(Map<String, dynamic> json) =>
    TravelDistance(
      json['text'] as String,
      json['value'] as int,
    );

Map<String, dynamic> _$TravelDistanceToJson(TravelDistance instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };

TravelDuration _$TravelDurationFromJson(Map<String, dynamic> json) =>
    TravelDuration(
      json['text'] as String,
      json['value'] as int,
    );

Map<String, dynamic> _$TravelDurationToJson(TravelDuration instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };
