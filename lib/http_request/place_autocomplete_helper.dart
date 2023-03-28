import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hometeam_client/json_model/address.dart' as property;
import 'package:hometeam_client/json_model/address_query.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';
import 'package:hometeam_client/utils/utils.dart';
import 'package:http/http.dart';

/// As defined on https://data.gov.hk/en-data/dataset/hk-ogcio-st_div_02-als
class PlaceAutocompleteHelper {
  static const authority = 'www.als.ogcio.gov.hk';
  static const path = '/lookup';

  static Future<List<property.Address>> getSuggestions(
      BuildContext context, String query,
      {int suggestionCount = 5}) async {
    if (query.isEmpty) return [];
    Response response = await PlaceAutocompleteHelper._query(context, query,
        suggestionCount: suggestionCount);
    return _parseResponse(response);
  }

  static Future<Response> _query(BuildContext context, String query,
      {int suggestionCount = 5}) {
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

          bool chinese = premises.chiPremisesAddress != null;
          String? blockDescriptor,
              blockNumber,
              buildingName,
              estateName,
              phaseName,
              streetName,
              streetNumberFrom,
              streetNumberTo;
          late String streetAddress;
          late String block, addressLine1, addressLine2, region, district;
          if (chinese) {
            var address = premises.chiPremisesAddress!;
            blockNumber = address.chiBlock?.blockNo;
            blockDescriptor = address.chiBlock?.blockDescriptor;
            buildingName = address.buildingName?.toHalfWidth();
            estateName = address.chiEstate?.estateName;
            phaseName = address.chiEstate?.phase?.phaseName;
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
            phaseName = address.engEstate?.phase?.phaseName;
            streetName = address.engStreet?.streetName;
            streetNumberFrom = address.engStreet?.buildingNoFrom;
            streetNumberTo = address.engStreet?.buildingNoTo;
            district = address.engStreet?.locationName ?? '';
            region = _getRegionName(address.region);

            // todo block number, block descriptor may not be present, try querying 'r'
            // if (block.isNotEmpty) {
            //   if (blockDescriptor != null) {
            //     block = blockDescriptorPrecedenceIndicator == 'Y'
            //         ? '$blockDescriptor $block'
            //         : '$block $blockDescriptor';
            //   }
            // }

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

          // todo only extract alphanumerical "blocks"
          if (blockDescriptor == '座' ||
              blockDescriptor == 'BLK' ||
              blockDescriptor == 'BLKS' ||
              blockDescriptor == 'BLOCK') {
            block = blockNumber ?? '';
          } else {
            // todo extract block name from building name
            // todo block = '${blockNumber ?? ''}${blockDescriptor ?? ''}';
          }
          // todo Standardize address (parse into address line 1 and 2)
          // Sometimes the API returns unnecessary block name
          // if(buildingName != null) {
          //   if(estateName != null) {
          //     block = '';
          //   } else {
          //
          //   }
          // }
          // if(buildingName != null && estateName != null) {
          //   block = '';
          // } else {
          //   if (buildingName.contains(estateName)) {
          //
          //   }
          //   block = blockNumber ?? '';
          // }
          // block = buildingName != null && estateName != null
          //     ? ''
          //     : blockNumber ?? '';
          // todo extract block name from building name

          addressLine1 = buildingName ?? estateName ?? '';
          // if (addressLine1 == estateName) {
          //   if (block.isNotEmpty) {
          //     addressLine1 = chinese
          //         ? blockDescriptor == null
          //             ? '$estateName $block'
          //             : '$estateName$block'
          //         : '$block $estateName';
          //   }
          // }

          if (buildingName != null) {
            addressLine2 = estateName ?? streetAddress;
            if (estateName != null) {
              if (buildingName.contains(estateName)) {
                var blockStr = buildingName.replaceAll(estateName, '').trim();
                debugPrint('S:$blockStr');
                // todo remove block descriptor
                // addressLine1 = '';
                // todo extract the block number, e.g. A, 1, A1, 二
              }
            }
          } else {
            addressLine2 = streetAddress;
          }
          // todo if district is empty, try querying for it, example: 曉翠苑
          suggestions.add(property.Address(
              //todo block: block,
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
