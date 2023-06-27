import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<File> images;

  List<String> imageNames;

  Room({List<File>? images, List<String>? imageNames})
      : images = images ?? [],
        imageNames = imageNames ?? [];

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() {
    imageNames = images.map((e) => basename(e.path)).toList();
    return _$RoomToJson(this);
  }
}
