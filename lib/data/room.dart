import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';


class Room {
  final RoomType type;
  List<File> images = [];

  Room(this.type);
}

enum RoomType {
  livingDiningRoom, bedroom, bathroom, others
}

class RoomHelper {
  static IconData getIconData(RoomType roomType) {
    switch(roomType) {
      case RoomType.livingDiningRoom:
        return Icons.chair_outlined;
      case RoomType.bedroom:
        return Icons.bed_outlined;
      case RoomType.bathroom:
        return Icons.bathtub_outlined;
      case RoomType.others:
        return Icons.other_houses_outlined;
    }
  }

  static String getName(BuildContext context, RoomType roomType) {
    switch(roomType) {
      case RoomType.livingDiningRoom:
        return S.of(context).living_dining_room;
      case RoomType.bedroom:
        return S.of(context).bedroom;
      case RoomType.bathroom:
        return S.of(context).bathroom;
      case RoomType.others:
        return S.of(context).others;
    }
  }
}