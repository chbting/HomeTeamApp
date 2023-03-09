import 'package:flutter/material.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/contract.dart';
import 'package:hometeam_client/json_model/listing.dart';

class Property {
  final int id;
  final Address address;
  int netArea;
  int grossArea;
  int room;
  int bathroom; // todo 0.5
  int coveredParking;
  int openParking;
  ImageProvider coverImage;
  Contract contract;
  Listing listing;

  //todo list of images

  Property(
      {this.id = -1,
      required this.address,
      this.netArea = -1,
      this.grossArea = -1,
      this.room = -1,
      this.bathroom = -1,
      this.coveredParking = -1,
      this.openParking = -1,
      required this.coverImage,
      required this.contract,
      required this.listing});
}
