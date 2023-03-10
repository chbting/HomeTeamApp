import 'package:flutter/material.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';
import 'package:http/http.dart';

/// As defined on https://data.gov.hk/en-data/dataset/hk-ogcio-st_div_02-als
class PlaceAutocompleteHelper {
  static const authority = 'www.als.ogcio.gov.hk';
  static const path = '/lookup';

  static Future<Response> query(
      BuildContext context, String query) async {
    Uri request = Uri.https(authority, path, {'q': query});

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
    debugPrint('request:$request');
    return get(request, headers: headers);
  }
}
