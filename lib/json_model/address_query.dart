// To parse this JSON data, do
//
//     final addressQuery = addressQueryFromJson(jsonString);

import 'dart:convert';

class AddressQuery {
  AddressQuery({
    required this.requestAddress,
    this.suggestedAddress,
  });

  final RequestAddress requestAddress;
  final List<SuggestedAddress>? suggestedAddress;

  factory AddressQuery.fromRawJson(String str) =>
      AddressQuery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressQuery.fromJson(Map<String, dynamic> json) => AddressQuery(
        requestAddress: RequestAddress.fromJson(json["RequestAddress"]),
        suggestedAddress: json["SuggestedAddress"] == null
            ? null
            : List<SuggestedAddress>.from(json["SuggestedAddress"]
                .map((x) => SuggestedAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RequestAddress": requestAddress.toJson(),
        "SuggestedAddress": suggestedAddress == null
            ? null
            : List<dynamic>.from(suggestedAddress!.map((x) => x.toJson())),
      };
}

class RequestAddress {
  RequestAddress({
    required this.addressLine,
  });

  final List<String> addressLine;

  factory RequestAddress.fromRawJson(String str) =>
      RequestAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestAddress.fromJson(Map<String, dynamic> json) => RequestAddress(
        addressLine: List<String>.from(json["AddressLine"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "AddressLine": List<dynamic>.from(addressLine.map((x) => x)),
      };
}

class SuggestedAddress {
  SuggestedAddress({
    required this.address,
    required this.validationInformation,
  });

  final Address address;
  final ValidationInformation validationInformation;

  factory SuggestedAddress.fromRawJson(String str) =>
      SuggestedAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SuggestedAddress.fromJson(Map<String, dynamic> json) =>
      SuggestedAddress(
        address: Address.fromJson(json["Address"]),
        validationInformation:
            ValidationInformation.fromJson(json["ValidationInformation"]),
      );

  Map<String, dynamic> toJson() => {
        "Address": address.toJson(),
        "ValidationInformation": validationInformation.toJson(),
      };
}

class Address {
  Address({
    required this.premisesAddress,
  });

  final PremisesAddress premisesAddress;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        premisesAddress: PremisesAddress.fromJson(json["PremisesAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "PremisesAddress": premisesAddress.toJson(),
      };
}

class PremisesAddress {
  PremisesAddress({
    this.engPremisesAddress,
    this.chiPremisesAddress,
    required this.geoAddress,
    required this.geospatialInformation,
  });

  final EngPremisesAddress? engPremisesAddress;
  final ChiPremisesAddress? chiPremisesAddress;
  final String geoAddress;
  final GeospatialInformation geospatialInformation;

  factory PremisesAddress.fromRawJson(String str) =>
      PremisesAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PremisesAddress.fromJson(Map<String, dynamic> json) =>
      PremisesAddress(
        engPremisesAddress: json['EngPremisesAddress'] == null
            ? null
            : EngPremisesAddress.fromJson(json['EngPremisesAddress']),
        chiPremisesAddress: json['ChiPremisesAddress'] == null
            ? null
            : ChiPremisesAddress.fromJson(json['ChiPremisesAddress']),
        geoAddress: json["GeoAddress"],
        geospatialInformation:
            GeospatialInformation.fromJson(json["GeospatialInformation"]),
      );

  Map<String, dynamic> toJson() => {
        "EngPremisesAddress": engPremisesAddress?.toJson(),
        "ChiPremisesAddress": chiPremisesAddress?.toJson(),
        "GeoAddress": geoAddress,
        "GeospatialInformation": geospatialInformation.toJson(),
      };
}

class ChiPremisesAddress {
  ChiPremisesAddress({
    required this.region,
    required this.chiDistrict,
    required this.chiStreet,
    this.buildingName,
    this.chiEstate,
    this.chiBlock,
  });

  final String region;
  final District chiDistrict;
  final Street? chiStreet;
  final String? buildingName;
  final ChiEstate? chiEstate;
  final ChiBlock? chiBlock;

  factory ChiPremisesAddress.fromRawJson(String str) =>
      ChiPremisesAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChiPremisesAddress.fromJson(Map<String, dynamic> json) =>
      ChiPremisesAddress(
        region: json["Region"],
        chiDistrict: District.fromJson(json["ChiDistrict"]),
        chiStreet: json["ChiStreet"] == null
            ? null
            : Street.fromJson(json["ChiStreet"]),
        buildingName: json["BuildingName"],
        chiEstate: json["ChiEstate"] == null
            ? null
            : ChiEstate.fromJson(json["ChiEstate"]),
        chiBlock: json["ChiBlock"] == null
            ? null
            : ChiBlock.fromJson(json["ChiBlock"]),
      );

  Map<String, dynamic> toJson() => {
        "Region": region,
        "ChiDistrict": chiDistrict.toJson(),
        "ChiStreet": chiStreet?.toJson(),
        "BuildingName": buildingName,
        "ChiEstate": chiEstate?.toJson(),
        "ChiBlock": chiBlock?.toJson(),
      };
}

class ChiBlock {
  ChiBlock({
    this.blockDescriptor,
    this.blockNo,
  });

  final String? blockDescriptor;
  final String? blockNo;

  factory ChiBlock.fromRawJson(String str) =>
      ChiBlock.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChiBlock.fromJson(Map<String, dynamic> json) => ChiBlock(
        blockDescriptor: json["BlockDescriptor"],
        blockNo: json["BlockNo"],
      );

  Map<String, dynamic> toJson() => {
        "BlockDescriptor": blockDescriptor,
        "BlockNo": blockNo,
      };
}

class District {
  District({
    required this.dcDistrict,
  });

  final String dcDistrict;

  factory District.fromRawJson(String str) =>
      District.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory District.fromJson(Map<String, dynamic> json) => District(
        dcDistrict: json["DcDistrict"],
      );

  Map<String, dynamic> toJson() => {
        "DcDistrict": dcDistrict,
      };
}

class ChiEstate {
  ChiEstate({required this.estateName, this.phase});

  final String estateName;
  final Phase? phase;

  factory ChiEstate.fromRawJson(String str) =>
      ChiEstate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChiEstate.fromJson(Map<String, dynamic> json) =>
      ChiEstate(estateName: json["EstateName"], phase: json["ChiPhase"]);

  Map<String, dynamic> toJson() =>
      {"EstateName": estateName, "ChiPhase": phase};
}

class EngEstate {
  EngEstate({required this.estateName, this.phase});

  final String estateName;
  final Phase? phase;

  factory EngEstate.fromRawJson(String str) =>
      EngEstate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EngEstate.fromJson(Map<String, dynamic> json) =>
      EngEstate(estateName: json["EstateName"], phase: json["EngPhase"]);

  Map<String, dynamic> toJson() =>
      {"EstateName": estateName, "EngPhase": phase};
}

class Phase {
  Phase({this.phaseName, this.phaseNo});

  final String? phaseName;
  final String? phaseNo;

  factory Phase.fromRawJson(String str) => Phase.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Phase.fromJson(Map<String, dynamic> json) => Phase(
        phaseName: json["PhaseName"],
        phaseNo: json["PhaseNo"],
      );

  Map<String, dynamic> toJson() => {
        "PhaseName": phaseName,
        "PhaseNo": phaseNo,
      };
}

class Street {
  Street(
      {this.locationName,
      required this.streetName,
      this.buildingNoFrom,
      this.buildingNoTo});

  final String? locationName;
  final String streetName;
  final String? buildingNoFrom;
  final String? buildingNoTo;

  factory Street.fromRawJson(String str) => Street.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Street.fromJson(Map<String, dynamic> json) => Street(
        locationName: json["LocationName"],
        streetName: json["StreetName"],
        buildingNoFrom: json["BuildingNoFrom"],
        buildingNoTo: json["BuildingNoTo"],
      );

  Map<String, dynamic> toJson() => {
        "LocationName": locationName,
        "StreetName": streetName,
        "BuildingNoFrom": buildingNoFrom,
        "BuildingNoTo": buildingNoTo,
      };
}

class EngPremisesAddress {
  EngPremisesAddress({
    this.engStreet,
    required this.engDistrict,
    required this.region,
    this.buildingName,
    this.engBlock,
    this.engEstate,
  });

  final Street? engStreet;
  final District engDistrict;
  final String region;
  final String? buildingName;
  final EngBlock? engBlock;
  final EngEstate? engEstate;

  factory EngPremisesAddress.fromRawJson(String str) =>
      EngPremisesAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EngPremisesAddress.fromJson(Map<String, dynamic> json) =>
      EngPremisesAddress(
        engStreet: json["EngStreet"] == null
            ? null
            : Street.fromJson(json["EngStreet"]),
        engDistrict: District.fromJson(json["EngDistrict"]),
        region: json["Region"],
        buildingName: json["BuildingName"],
        engBlock: json["EngBlock"] == null
            ? null
            : EngBlock.fromJson(json["EngBlock"]),
        engEstate: json["EngEstate"] == null
            ? null
            : EngEstate.fromJson(json["EngEstate"]),
      );

  Map<String, dynamic> toJson() => {
        "EngStreet": engStreet?.toJson(),
        "EngDistrict": engDistrict.toJson(),
        "Region": region,
        "BuildingName": buildingName,
        "EngBlock": engBlock?.toJson(),
        "EngEstate": engEstate?.toJson(),
      };
}

class EngBlock {
  EngBlock({
    required this.blockDescriptor,
    required this.blockNo,
    required this.blockDescriptorPrecedenceIndicator,
  });

  final String blockDescriptor;
  final String blockNo;
  final String blockDescriptorPrecedenceIndicator;

  factory EngBlock.fromRawJson(String str) =>
      EngBlock.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EngBlock.fromJson(Map<String, dynamic> json) => EngBlock(
        blockDescriptor: json["BlockDescriptor"],
        blockNo: json["BlockNo"],
        blockDescriptorPrecedenceIndicator:
            json["BlockDescriptorPrecedenceIndicator"],
      );

  Map<String, dynamic> toJson() => {
        "BlockDescriptor": blockDescriptor,
        "BlockNo": blockNo,
        "BlockDescriptorPrecedenceIndicator":
            blockDescriptorPrecedenceIndicator,
      };
}

class GeospatialInformation {
  GeospatialInformation({
    required this.northing,
    required this.easting,
    required this.latitude,
    required this.longitude,
  });

  final String northing;
  final String easting;
  final String latitude;
  final String longitude;

  factory GeospatialInformation.fromRawJson(String str) =>
      GeospatialInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeospatialInformation.fromJson(Map<String, dynamic> json) =>
      GeospatialInformation(
        northing: json["Northing"],
        easting: json["Easting"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
      );

  Map<String, dynamic> toJson() => {
        "Northing": northing,
        "Easting": easting,
        "Latitude": latitude,
        "Longitude": longitude,
      };
}

class ValidationInformation {
  ValidationInformation({
    required this.score,
  });

  final double score;

  factory ValidationInformation.fromRawJson(String str) =>
      ValidationInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ValidationInformation.fromJson(Map<String, dynamic> json) =>
      ValidationInformation(
        score: json["Score"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Score": score,
      };
}
