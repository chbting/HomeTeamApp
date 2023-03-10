import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/contract.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/tenant.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';

Tenant getSampleClientData() {
  var chinese = SharedPreferencesHelper.getLocale().languageCode == 'zh';
  Tenant tenant = Tenant(
      address: Address(
          addressLine1: chinese ? '1座2樓C室' : 'Flat C, 2/F, Block 1',
          addressLine2: chinese ? '雅佳花園' : 'Bayview Garden',
          district: chinese ? '上環' : 'Sheung Wan',
          region: chinese ? '香港' : 'Hong Kong'));
  tenant.firstName = chinese ? '大明' : 'David';
  tenant.lastName = chinese ? '陳' : 'Johnson';
  tenant.title = chinese ? '先生' : 'Mr.';
  tenant.idCardNumber = 'A123456(7)';
  tenant.phoneNumber = '12345678';
  tenant.email = 'demo@email.com';
  return tenant;
}

List<Property> getSampleProperties() {
  return _sampleProperties.toList();
}

// todo English sample
final List<Address> addresses = [
  Address(
      addressLine1: '第5座10樓',
      addressLine2: '康翠臺',
      district: '柴灣',
      region: '香港'),
  Address(
      addressLine1: '聚賢居第1座35樓',
      addressLine2: '聚賢居',
      district: '上環',
      region: '香港'),
  Address(
      addressLine1: '尚翹峰22樓',
      addressLine2: '尚翹峰',
      district: '灣仔',
      region: '香港'),
  Address(
      addressLine1: '容龍居20樓C室',
      addressLine2: '容龍居',
      district: '屯門',
      region: '新界'),
  Address(
      addressLine1: '景湖居3座',
      addressLine2: '嘉湖山莊',
      district: '天水圍',
      region: '新界'),
  Address(
      addressLine1: '海逸豪園2期 玉庭軒10座',
      addressLine2: '海逸豪園',
      district: '紅磡',
      region: '九龍'), //notes: google map inaccuracy for this address
  Address(
      addressLine1: '麗港城9座14樓',
      addressLine2: '麗港城',
      district: '藍田',
      region: '九龍'),
  Address(
      addressLine1: '珀麗灣1期16座',
      addressLine2: '珀麗灣',
      district: '馬灣',
      region: '新界'),
  Address(
      addressLine1: '粉嶺名都富臨閣20樓',
      addressLine2: '粉嶺名都',
      district: '粉嶺',
      region: '新界'),
];

final List<Property> _sampleProperties = [
  Property(
      address: addresses[0],
      netArea: 630,
      grossArea: 720,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[0],
      contract: Contract(monthlyRent: _rents[0], deposit: _rents[0] * 2),
      listing: Listing(title: addresses[0].addressLine2)),
  Property(
      address: addresses[1],
      netArea: 631,
      grossArea: 721,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[1],
      contract: Contract(monthlyRent: _rents[1], deposit: _rents[1] * 2),
      listing: Listing(title: addresses[1].addressLine2)),
  Property(
      address: addresses[2],
      netArea: 520,
      grossArea: 601,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[2],
      contract: Contract(monthlyRent: _rents[2], deposit: _rents[2] * 2),
      listing: Listing(title: addresses[2].addressLine2)),
  Property(
      address: addresses[3],
      netArea: 407,
      grossArea: 494,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[3],
      contract: Contract(monthlyRent: _rents[3], deposit: _rents[3] * 2),
      listing: Listing(title: addresses[3].addressLine2)),
  Property(
      address: addresses[4],
      netArea: 783,
      grossArea: 906,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[4],
      contract: Contract(monthlyRent: _rents[4], deposit: _rents[4] * 2),
      listing: Listing(title: addresses[4].addressLine2)),
  Property(
      address: addresses[5],
      netArea: 592,
      grossArea: 722,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[5],
      contract: Contract(monthlyRent: _rents[5], deposit: _rents[5] * 2),
      listing: Listing(title: addresses[5].addressLine2)),
  Property(
      address: addresses[6],
      netArea: 517,
      grossArea: 639,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[6],
      contract: Contract(monthlyRent: _rents[6], deposit: _rents[6] * 2),
      listing: Listing(title: addresses[6].addressLine2)),
  Property(
      address: addresses[7],
      netArea: 1068,
      grossArea: 1362,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[7],
      contract: Contract(monthlyRent: _rents[7], deposit: _rents[7] * 2),
      listing: Listing(title: addresses[7].addressLine2)),
  Property(
      address: addresses[8],
      netArea: 369,
      grossArea: 500,
      room: 2,
      bathroom: 1,
      coverImage: _sampleCoverImage[8],
      contract: Contract(monthlyRent: _rents[8], deposit: _rents[8] * 2),
      listing: Listing(title: addresses[8].addressLine2))
];

List<AssetImage> _sampleCoverImage = [
  const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg'),
  const AssetImage('assets/demo_images/CentreStage_240px.jpg'),
  const AssetImage('assets/demo_images/The_Zenith_240px.jpg'),
  const AssetImage('assets/demo_images/dragon_inn_court_240px.png'),
  const AssetImage('assets/demo_images/kenswood_court_240px.png'),
  const AssetImage('assets/demo_images/laguna_verde_240px.png'),
  const AssetImage('assets/demo_images/laguna_city_240px.png'),
  const AssetImage('assets/demo_images/park_island_240px.png'),
  const AssetImage('assets/demo_images/fanling_town_centre_240px.png')
];

List<int> _rents = [
  18400,
  32000,
  24000,
  15000,
  32000,
  23000,
  17500,
  42000,
  13000
];
