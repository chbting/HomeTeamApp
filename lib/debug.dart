import 'package:flutter/material.dart';
import 'package:hometeam_client/data/appliance.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/json_model/tenant.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';

class Debug {
  static const emulatorIp = '192.168.0.39';
  static final List<AssetImage> _sampleCoverImage = [
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

  static final List<int> _rents = [
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

  // todo English sample
  static final List<Address> addresses = [
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

  static Tenant getSampleClientData() {
    var chinese = SharedPreferencesHelper.getLocale().languageCode == 'zh';
    Tenant tenant = Tenant();
    tenant.firstName = chinese ? '大明' : 'David';
    tenant.lastName = chinese ? '陳' : 'Johnson';
    tenant.title = chinese ? '先生' : 'Mr.';
    tenant.idCardNumber = 'A123456(7)';
    tenant.phoneNumber = '12345678';
    tenant.email = 'demo@email.com';
    return tenant;
  }

  static List<Listing> getSampleListing() {
    var properties = getSampleProperties();
    List<Listing> listings = [];
    for (int i = 0; i < properties.length; i++) {
      listings.add(Listing(
          title: properties[i].address.addressLine2,
          propertyId: properties[i].id,
          terms: Terms(
              propertyId: properties[i].id,
              rent: _rents[i],
              deposit: _rents[i] * 2)));
    }
    return listings;
  }

  static List<Property> getSampleProperties() {
    return [
      Property(
          id: '1',
          address: addresses[0],
          netArea: 630,
          grossArea: 720,
          bedroom: 2,
          bathroom: 1,
          coveredParking: 1,
          openParking: 0,
          coverImage: _sampleCoverImage[0],
          appliances: {
            Appliance.ac : 2,
            Appliance.stove : true,
            Appliance.fridge : true,
            Appliance.dryer : false,
            Appliance.washer : false,
            Appliance.washerDryerCombo : true,
            Appliance.waterHeater : true,
            Appliance.rangeHood : true
          }),
      Property(
          id: '2',
          address: addresses[1],
          netArea: 631,
          grossArea: 721,
          bedroom: 2,
          bathroom: 1,
          coverImage: _sampleCoverImage[1],
          appliances: {
            Appliance.ac : 3,
            Appliance.stove : true,
            Appliance.fridge : false,
            Appliance.dryer : false,
            Appliance.washer : false,
            Appliance.washerDryerCombo : true,
            Appliance.waterHeater : true,
            Appliance.rangeHood : true
          }),
      Property(
          id: '3',
          address: addresses[2],
          netArea: 520,
          grossArea: 601,
          bedroom: 2,
          bathroom: 1,
          coverImage: _sampleCoverImage[2]),
      Property(
          id: '4',
          address: addresses[3],
          netArea: 407,
          grossArea: 494,
          bedroom: 2,
          bathroom: 1,
          coverImage: _sampleCoverImage[3]),
      Property(
          id: '5',
          address: addresses[4],
          netArea: 783,
          grossArea: 906,
          bedroom: 2,
          bathroom: 1,
          coverImage: _sampleCoverImage[4]),
      Property(
          id: '6',
          address: addresses[5],
          netArea: 592,
          grossArea: 722,
          bedroom: 2,
          bathroom: 1,
          coverImage: _sampleCoverImage[5]),
      Property(
          id: '7',
          address: addresses[6],
          netArea: 517,
          grossArea: 639,
          bedroom: 2,
          bathroom: 1,
          coverImage: _sampleCoverImage[6]),
      Property(
          id: '8',
          address: addresses[7],
          netArea: 1068,
          grossArea: 1362,
          bedroom: 2,
          bathroom: 1,
          coverImage: _sampleCoverImage[7]),
      Property(
          id: '9',
          address: addresses[8],
          netArea: 369,
          grossArea: 500,
          bedroom: 2,
          bathroom: 1,
          coverImage: _sampleCoverImage[8])
    ];
  }
}
