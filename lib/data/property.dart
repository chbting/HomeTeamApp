import 'package:flutter/material.dart';
import 'package:hometeam_client/data/room.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/contract.dart';
import 'package:hometeam_client/json_model/listing.dart';

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
  Contract contract = Contract();
  Listing listing = Listing(title: '');

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
      required this.coverImage,
      required this.contract,
      required this.listing});

  Property.empty(
      {this.id = -1,
      this.netArea = -1,
      this.grossArea = -1,
      this.bedroom = 2,
      this.bathroom = 2, // todo
      this.coveredParking = -1,
      this.openParking = -1});
}
