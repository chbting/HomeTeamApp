import 'package:flutter/material.dart';
import 'package:hometeam_client/data/room.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/json_model/address.dart';

class Property {
  final int id;
  Address address = Address();
  int netArea;
  int grossArea;
  int bedroom;
  int bathroom; // todo 0.5
  int coveredParking;
  int openParking;
  final Map<int, Room> rooms = {};
  ImageProvider coverImage = const AssetImage('');
  //todo list of images

  Property(
      {this.id = -1,
      required this.address,
      this.netArea = -1,
      this.grossArea = -1,
      this.bedroom = -1,
      this.bathroom = -1,
      this.coveredParking = -1,
      this.openParking = -1,
      required this.coverImage});

  Property.empty(
      {this.id = -1,
      this.netArea = -1,
      this.grossArea = -1,
      this.bedroom = -1,
      this.bathroom = -1,
      this.coveredParking = -1,
      this.openParking = -1});
}

class PropertyHelper {
  static Property getFromId(int propertyId) {
    //todo
    return getSampleProperties()[propertyId];
  }
}