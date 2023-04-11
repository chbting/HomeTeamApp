// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
      lastName: json['lastName'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      idCardNumber: json['idCardNumber'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'title': instance.title,
      'idCardNumber': instance.idCardNumber,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
    };
