import 'dart:convert';

import 'package:hometeam_client/configs/keys.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/distance_matrix.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:http/http.dart';

class DistanceMatrixHelper {
  static const String authority = 'maps.googleapis.com';
  static const String path = 'maps/api/distancematrix/json';
  static const String responseLanguage = 'en';

  static Future<Response> getMatrix(List<Address> addresses) async {
    String origins = '';
    for (var address in addresses) {
      origins += '|$address'; //todo correct address form
    }
    origins =
        origins.substring(1, origins.length - 1); // remove the starting '|'
    String destinations = origins;

    Uri request =
    Uri.https(DistanceMatrixHelper.authority, DistanceMatrixHelper.path, {
      'origins': origins,
      'destinations': destinations,
      'language': DistanceMatrixHelper.responseLanguage,
      'key': distanceMatrixDebugKey
    });
    return get(request);
  }

  /// Parse the response into a map of travel times
  /// return Map<originId, Map<destinationId, duration>>
  /// todo use property id in instead of the object itself
  static Map<Listing, Map<Listing, int>>? parseResponse(
      Response response, List<Listing> listingsInCart) {
    Map<Listing, Map<Listing, int>> travelMap = {};

    if (response.statusCode == 200) {
      Map<String, dynamic> distanceMatrixMap = jsonDecode(response.body);
      DistanceMatrix distanceMatrix =
      DistanceMatrix.fromJson(distanceMatrixMap);
      if (distanceMatrix.status == 'OK') {
        for (var ori = 0; ori < listingsInCart.length; ori++) {
          Listing origin = listingsInCart[ori];
          travelMap[origin] = <Listing, int>{};

          for (var dest = 0; dest < listingsInCart.length; dest++) {
            Listing destination = listingsInCart[dest];
            if (origin != destination) {
              travelMap[origin]![destination] =
                  distanceMatrix.rows[ori].elements[dest].duration.value;
            }
          }
        }
        return travelMap;
      }
    }
    return null;
  }
}