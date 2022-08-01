// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'distance_matrix.g.dart';

const String distanceMatrixURL =
    'https://maps.googleapis.com/maps/api/distancematrix/';
const String distanceMatrixResponseFormat = 'json';
const String distanceMatrixResponseLanguage = 'en';

@JsonSerializable()
class DistanceMatrix {
  DistanceMatrix(this.destination_addresses, this.origin_addresses, this.rows,
      this.status);

  List<String> destination_addresses;
  List<String> origin_addresses;
  List<DistanceMatrixElements> rows;
  String status;

  factory DistanceMatrix.fromJson(Map<String, dynamic> json) =>
      _$DistanceMatrixFromJson(json);

  Map<String, dynamic> toJson() => _$DistanceMatrixToJson(this);
}

@JsonSerializable()
class DistanceMatrixElements {
  DistanceMatrixElements(this.elements);

  List<DistanceMatrixElement> elements;

  factory DistanceMatrixElements.fromJson(Map<String, dynamic> json) =>
      _$DistanceMatrixElementsFromJson(json);

  Map<String, dynamic> toJson() => _$DistanceMatrixElementsToJson(this);
}

@JsonSerializable()
class DistanceMatrixElement {
  DistanceMatrixElement(this.distance, this.duration, this.status);

  TravelDistance distance;
  TravelDuration duration;
  String status;

  factory DistanceMatrixElement.fromJson(Map<String, dynamic> json) =>
      _$DistanceMatrixElementFromJson(json);

  Map<String, dynamic> toJson() => _$DistanceMatrixElementToJson(this);
}

@JsonSerializable()
class TravelDistance {
  TravelDistance(this.text, this.value);

  String text;
  int value;

  factory TravelDistance.fromJson(Map<String, dynamic> json) =>
      _$TravelDistanceFromJson(json);

  Map<String, dynamic> toJson() => _$TravelDistanceToJson(this);
}

@JsonSerializable()
class TravelDuration {
  TravelDuration(this.text, this.value);

  String text;
  int value;

  factory TravelDuration.fromJson(Map<String, dynamic> json) =>
      _$TravelDurationFromJson(json);

  Map<String, dynamic> toJson() => _$TravelDurationToJson(this);
}
