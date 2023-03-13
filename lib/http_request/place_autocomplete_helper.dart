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

  static Future<Response> query(BuildContext context, String query,
      {int suggestionCount = 5}) async {
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

  static List<property.Address> parseResponse(Response response) {
    List<property.Address> suggestions = [];

    if (response.statusCode == 200) {
      AddressQuery addressQuery =
          AddressQuery.fromJson(jsonDecode(response.body));

      if (addressQuery.suggestedAddress != null) {
        for (var suggestedAddress in addressQuery.suggestedAddress!) {
          PremisesAddress premises = suggestedAddress.address.premisesAddress;

          late String region, district;
          if (premises.chiPremisesAddress != null) {
            var address = premises.chiPremisesAddress!;
            district = address.chiStreet.locationName ?? '';
            region = address.region;
          } else {
            //
            var address = premises.engPremisesAddress!;
            district = address.engStreet.locationName ?? '';
            region = _getRegionName(address.region);
          }
          //todo parse more details
          suggestions.add(property.Address(district: district, region: region));
        }
      }
    }
    debugPrint('$suggestions');
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
