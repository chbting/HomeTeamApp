import 'package:flutter/material.dart';
import 'package:hometeam_client/data/appliance.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/room.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable(explicitToJson: true)
class Property {
  final String id;
  Address address;
  int netArea;
  int grossArea;
  int bedroom;
  int bathroom;
  int coveredParking;
  int openParking;
  final Map<int, Room> rooms;
  Map<Appliance, dynamic> appliances;

  @JsonKey(includeToJson: false, includeFromJson: false) //todo
  ImageProvider coverImage;

  Property(
      {this.id = '',
      required this.address,
      this.netArea = -1,
      this.grossArea = -1,
      this.bedroom = -1,
      this.bathroom = -1,
      this.coveredParking = -1,
      this.openParking = -1,
      ImageProvider? coverImage})
      : appliances = {},
        rooms = {},
        coverImage = coverImage ?? const AssetImage('');

  Property.empty(
      {this.id = '',
      this.netArea = -1,
      this.grossArea = -1,
      this.bedroom = -1,
      this.bathroom = -1,
      this.coveredParking = -1,
      this.openParking = -1})
      : address = Address(),
        appliances = {},
        rooms = {},
        coverImage = const AssetImage('') {
    for (var appliance in Appliance.values) {
      appliances[appliance] = ApplianceHelper.getDefaultValue(appliance);
    }
  }

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}

class PropertyHelper {
  static Property getFromId(String propertyId) {
    //todo
    return getSampleProperties()
        .firstWhere((property) => property.id == propertyId);
  }
}
