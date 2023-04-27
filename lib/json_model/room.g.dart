// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      $enumDecode(_$RoomTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'type': _$RoomTypeEnumMap[instance.type]!,
    };

const _$RoomTypeEnumMap = {
  RoomType.livingDiningRoom: 'livingDiningRoom',
  RoomType.bedroom: 'bedroom',
  RoomType.bathroom: 'bathroom',
  RoomType.others: 'others',
};
