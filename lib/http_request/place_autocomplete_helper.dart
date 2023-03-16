import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hometeam_client/json_model/address.dart' as property;
import 'package:hometeam_client/json_model/address_query.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';
import 'package:http/http.dart';

/// As defined on https://data.gov.hk/en-data/dataset/hk-ogcio-st_div_02-als
class PlaceAutocompleteHelper {
  static const authority = 'www.als.ogcio.gov.hk';
  static const path = '/lookup';

  static Future<List<property.Address>> getSuggestions(
      BuildContext context, String query) async {
    if (query.isEmpty) return [];
    Response response = await PlaceAutocompleteHelper._query(context, query);
    return _parseResponse(response);
  }

  static Future<Response> _query(BuildContext context, String query,
      {int suggestionCount = 3}) {
    Uri request = Uri.https(
        authority, path, {'q': query, 'n': suggestionCount.toString()});

    late String languageCode;
    switch (SharedPreferencesHelper.getLocale().languageCode) {
      case 'zh':
        languageCode = 'zh-Hant';
        break;
      case 'en':
      default:
        languageCode = 'en';
        break;
    }
    Map<String, String>? headers = {
      'accept': 'application/json',
      'Accept-Language': languageCode
    };
    return get(request, headers: headers);
  }

  static List<property.Address> _parseResponse(Response response) {
    List<property.Address> suggestions = [];

    if (response.statusCode == 200) {
      AddressQuery addressQuery =
          AddressQuery.fromJson(jsonDecode(response.body));

      if (addressQuery.suggestedAddress != null) {
        for (var suggestedAddress in addressQuery.suggestedAddress!) {
          PremisesAddress premises = suggestedAddress.address.premisesAddress;

          String? blockNumber,
              blockDescriptor,
              buildingName,
              estateName,
              streetName,
              streetNumberFrom,
              streetNumberTo;
          late String streetAddress;
          late String addressLine1, addressLine2, region, district;
          if (premises.chiPremisesAddress != null) {
            var address = premises.chiPremisesAddress!;
            blockNumber = address.chiBlock?.blockNo;
            blockDescriptor = address.chiBlock?.blockDescriptor;
            buildingName = address.buildingName;
            estateName = address.chiEstate?.estateName;
            streetName = address.chiStreet?.streetName;
            streetNumberFrom = address.chiStreet?.buildingNoFrom;
            streetNumberTo = address.chiStreet?.buildingNoTo;
            district = address.chiStreet?.locationName ?? '';
            region = address.region;

            streetAddress = streetName ?? '';
            if (streetAddress.isNotEmpty) {
              streetAddress += streetNumberFrom ?? '';
              streetAddress +=
                  streetNumberTo == null ? '號' : '-$streetNumberTo號';
            }
          } else {
            String? blockDescriptorPrecedenceIndicator;
            var address = premises.engPremisesAddress!;
            blockNumber = address.engBlock?.blockNo;
            blockDescriptor = address.engBlock?.blockDescriptor;
            blockDescriptorPrecedenceIndicator =
                address.engBlock?.blockDescriptorPrecedenceIndicator;
            buildingName = address.buildingName;
            estateName = address.engEstate?.estateName;
            streetName = address.engStreet?.streetName;
            streetNumberFrom = address.engStreet?.buildingNoFrom;
            streetNumberTo = address.engStreet?.buildingNoTo;
            district = address.engStreet?.locationName ?? '';
            region = _getRegionName(address.region);

            streetAddress = streetName ?? '';
            if (streetAddress.isNotEmpty) {
              var streetNumber = streetNumberFrom ?? '';
              if (streetNumber.isNotEmpty) {
                streetNumber +=
                    streetNumberTo == null ? '' : '-$streetNumberTo';
                streetAddress = '$streetNumber $streetAddress';
              }
            }
          }
          // todo block number, block descriptor may not be present, try querying 'r'
          addressLine1 = buildingName ?? estateName ?? '';
          if (addressLine1 == estateName) {}
          if (buildingName != null) {
            addressLine2 = estateName ?? streetAddress;
          } else {
            addressLine2 = streetAddress;
          }
          // todo if district is empty, try querying for it, example: 曉翠苑
          suggestions.add(property.Address(
              addressLine1: addressLine1,
              addressLine2: addressLine2,
              district: district,
              region: region));
        }
      }
    }
    debugPrint('$suggestions'); //todo
    return suggestions;
  }

  static String _getRegionName(String regionCode) {
    switch (regionCode) {
      case 'NT':
        return 'New Territories';
      case 'KLN':
        return 'Kowloon';
      case 'HK':
      default:
        return 'Hong Kong';
    }
  }
}
