import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<File> images;

  List<String> imageUrls;

  Room({List<File>? images, List<String>? imageUrls})
      : images = images ?? [],
        imageUrls = imageUrls ?? [];

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
