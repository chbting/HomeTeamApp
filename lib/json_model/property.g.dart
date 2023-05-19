// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      netArea: json['netArea'] as int? ?? -1,
      grossArea: json['grossArea'] as int? ?? -1,
      bedroom: json['bedroom'] as int? ?? -1,
      bathroom: json['bathroom'] as int? ?? -1,
      coveredParking: json['coveredParking'] as int? ?? -1,
      openParking: json['openParking'] as int? ?? -1,
      appliances: (json['appliances'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$ApplianceEnumMap, k), e),
      ),
    )
      ..rooms = (json['rooms'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$RoomTypeEnumMap, k),
            (e as List<dynamic>)
                .map((e) => Room.fromJson(e as Map<String, dynamic>))
                .toList()),
      )
      ..videoUrl = json['videoUrl'] as String?
      ..created = json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String)
      ..updated = json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String);

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'address': instance.address.toJson(),
      'netArea': instance.netArea,
      'grossArea': instance.grossArea,
      'bedroom': instance.bedroom,
      'bathroom': instance.bathroom,
      'coveredParking': instance.coveredParking,
      'openParking': instance.openParking,
      'appliances': instance.appliances
          .map((k, e) => MapEntry(_$ApplianceEnumMap[k]!, e)),
      'rooms': instance.rooms.map((k, e) =>
          MapEntry(_$RoomTypeEnumMap[k]!, e.map((e) => e.toJson()).toList())),
      'videoUrl': instance.videoUrl,
    };

const _$ApplianceEnumMap = {
  Appliance.ac: 'ac',
  Appliance.waterHeater: 'waterHeater',
  Appliance.washer: 'washer',
  Appliance.dryer: 'dryer',
  Appliance.washerDryerCombo: 'washerDryerCombo',
  Appliance.fridge: 'fridge',
  Appliance.stove: 'stove',
  Appliance.rangeHood: 'rangeHood',
};

const _$RoomTypeEnumMap = {
  RoomType.livingDiningRoom: 'livingDiningRoom',
  RoomType.bedroom: 'bedroom',
  RoomType.bathroom: 'bathroom',
  RoomType.others: 'others',
};
