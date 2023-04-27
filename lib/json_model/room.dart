import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  final RoomType type;

  @JsonKey(includeToJson: false, includeFromJson: false) //todo
  List<File> images = [];

  factory Room.fromJson(Map<String, dynamic> json) =>
      _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  Room(this.type);
}

enum RoomType { livingDiningRoom, bedroom, bathroom, others }

class RoomHelper {
  static IconData getIconData(RoomType roomType) {
    switch (roomType) {
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
    switch (roomType) {
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
