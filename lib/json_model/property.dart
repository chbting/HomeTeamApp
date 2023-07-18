import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/data/appliance.dart';
import 'package:hometeam_client/data/room_type.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/room.dart';
import 'package:hometeam_client/utils/firebase_path.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'property.g.dart';

@JsonSerializable(explicitToJson: true)
class Property {
  @JsonKey(includeToJson: false, includeFromJson: false)
  String id;
  Address address;
  int netArea;
  int grossArea;
  int bedroom;
  int bathroom;
  int coveredParking;
  int openParking;

  /// Values are either bool or int (for ac)
  Map<Appliance, dynamic> appliances;

  /// Map of rooms, each room containing a list of images(json ignored) and imageUrls
  Map<RoomType, List<Room>> rooms;

  @JsonKey(includeToJson: false)
  DateTime? created;
  @JsonKey(includeToJson: false)
  DateTime? updated;

  //-- Variables below are for local use only--
  @JsonKey(includeToJson: false, includeFromJson: false)
  File? video;

  String? videoName;

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
      Map<Appliance, dynamic>? appliances,
      ImageProvider? coverImage})
      : appliances = appliances ?? {},
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

  factory Property.fromJson(String id, Map<String, dynamic> json) {
    Property property = Property._fromJson(json);
    property.id = id;
    return property;
  }

  factory Property._fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);

  Map<String, dynamic> toJson() {
    videoName = video == null ? null : basename(video!.path);
    return _$PropertyToJson(this);
  }
}

class PropertyHelper {
  static List<Property> cachedProperties = [];

  static Future<void> updateCache() {
    Completer<void> completer = Completer();
    FirebaseDatabase.instance
        .ref(FirebasePath.properties)
        .get()
        .then((snapshot) {
      List<Property> propertyList = [];
      if (snapshot.exists) {
        Map<String, dynamic> map = jsonDecode(jsonEncode(snapshot.value));
        map.forEach((key, value) {
          propertyList.add(Property.fromJson(key, value));
        });
      }
      cachedProperties = propertyList;
      completer.complete();
    });
    return completer.future;
  }

  static Property getFromId(String propertyId) {
    debugPrint('id:$propertyId');
    return cachedProperties.firstWhere((property) => property.id == propertyId); //todo
  }

  //todo remove
  static Property getFromIdDebug(String propertyId) {
    return Debug.getSampleProperties()
        .firstWhere((property) => property.id == propertyId);
  }
}
