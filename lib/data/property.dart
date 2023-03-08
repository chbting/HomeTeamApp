import 'package:flutter/material.dart';
import 'package:hometeam_client/data/address.dart';

class Property {
  final Address address;
  final String? title;
  final int id, sqFtGross, sqFtNet, monthlyRent, deposit;
  final ImageProvider coverImage;

  //Tenant paid fees
  final bool water = true;
  final bool electricity = true;
  final bool gas = true;
  final bool rates = true;
  final bool management = true;

  Property(this.id, this.title, this.address, this.sqFtGross, this.sqFtNet,
      this.monthlyRent, this.deposit, this.coverImage);
}

// todo English sample
List<Address> addresses = [
  Address(
      addressLine1: '第5座10樓',
      addressLine2: '康翠臺',
      district: '柴灣',
      region: Region.hongKong),
  Address(
      addressLine1: '聚賢居第1座35樓',
      addressLine2: '聚賢居',
      district: '上環',
      region: Region.hongKong),
  Address(
      addressLine1: '尚翹峰22樓',
      addressLine2: '尚翹峰',
      district: '灣仔',
      region: Region.hongKong),
  Address(
      addressLine1: '容龍居20樓C室',
      addressLine2: '容龍居',
      district: '屯門',
      region: Region.newTerritories),
  Address(
      addressLine1: '景湖居3座',
      addressLine2: '嘉湖山莊',
      district: '天水圍',
      region: Region.newTerritories),
  Address(
      addressLine1: '海逸豪園2期 玉庭軒10座',
      addressLine2: '海逸豪園',
      district: '紅磡',
      region: Region.kowloon), //notes: google map inaccuracy for this address
  Address(
      addressLine1: '麗港城9座14樓',
      addressLine2: '麗港城',
      district: '藍田',
      region: Region.kowloon),
  Address(
      addressLine1: '珀麗灣1期16座',
      addressLine2: '珀麗灣',
      district: '馬灣',
      region: Region.newTerritories),
  Address(
      addressLine1: '粉嶺名都富臨閣20樓',
      addressLine2: '粉嶺名都',
      district: '粉嶺',
      region: Region.newTerritories),
];

List<Property> _sampleProperties = [
  Property(1, addresses[0].addressLine2, addresses[0], 720, 630, 18400, 36800,
      const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
  Property(2, addresses[1].addressLine2, addresses[1], 631, 712, 32000, 64000,
      const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
  Property(3, addresses[2].addressLine2, addresses[2], 601, 520, 24000, 48000,
      const AssetImage('assets/demo_images/The_Zenith_240px.jpg')),
  Property(4, addresses[3].addressLine2, addresses[3], 494, 407, 15000, 30000,
      const AssetImage('assets/demo_images/dragon_inn_court_240px.png')),
  Property(5, addresses[4].addressLine2, addresses[4], 906, 783, 32000, 64000,
      const AssetImage('assets/demo_images/kenswood_court_240px.png')),
  Property(6, addresses[5].addressLine2, addresses[5], 722, 592, 23000, 46000,
      const AssetImage('assets/demo_images/laguna_verde_240px.png')),
  Property(7, addresses[6].addressLine2, addresses[6], 639, 517, 17500, 35000,
      const AssetImage('assets/demo_images/laguna_city_240px.png')),
  Property(8, addresses[7].addressLine2, addresses[7], 1362, 1068, 42000, 84000,
      const AssetImage('assets/demo_images/park_island_240px.png')),
  Property(9, addresses[8].addressLine2, addresses[8], 500, 369, 13000, 48000,
      const AssetImage('assets/demo_images/fanling_town_centre_240px.png'))
];

List<Property> getSampleProperties() {
  return _sampleProperties.toList();
}