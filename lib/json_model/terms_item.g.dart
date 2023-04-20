// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsItemSettings _$TermsItemSettingsFromJson(Map<String, dynamic> json) =>
    TermsItemSettings(
      negotiable: json['negotiable'] as bool,
      showToTenant: json['showToTenant'] as bool?,
    );

Map<String, dynamic> _$TermsItemSettingsToJson(TermsItemSettings instance) =>
    <String, dynamic>{
      'negotiable': instance.negotiable,
      'showToTenant': instance.showToTenant,
    };
