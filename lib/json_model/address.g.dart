// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      flat: json['flat'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      block: json['block'] as String? ?? '',
      blockDescriptor: json['blockDescriptor'] as String? ?? '',
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String? ?? '',
      district: json['district'] as String? ?? '',
      region: json['region'] as String? ?? '',
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'flat': instance.flat,
      'floor': instance.floor,
      'block': instance.block,
      'blockDescriptor': instance.blockDescriptor,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'district': instance.district,
      'region': instance.region,
    };
