import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tner_client/configs/keys.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/http_request/distance_matrix_request.dart';
import 'package:tner_client/json_model/distance_matrix.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/visit/property_visit_data.dart';
import 'package:tner_client/properties/visit/property_visit_scheduler.dart';
import 'package:tner_client/ui/property_list_tile.dart';
import 'package:tner_client/ui/theme.dart';

class PropertyVisitCartScreen extends StatefulWidget {
  const PropertyVisitCartScreen({Key? key}) : super(key: key);

  @override
  State<PropertyVisitCartScreen> createState() =>
      PropertyVisitCartScreenState();
}

class PropertyVisitCartScreenState extends State<PropertyVisitCartScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool _showFab = _propertiesCart.isNotEmpty;

  //todo show some messages for user to add items if empty

  final double _imageSize = 120.0;
  final List<Property> _propertiesCart = getSamplePropertyVisitList2();
  final Map<Property, Map<Property, int>> _travelMap =
      {}; // Map<originId, Map<destinationId, duration>>
  late List<Property> _currentPath, _optimizedPath;
  late int _optimizedTravelTime;
  bool _showProgressIndicator = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          floatingActionButton: Visibility(
              visible: _showFab,
              child: FloatingActionButton.extended(
                  heroTag: "properties_visit_cart_fab",
                  icon: const Icon(Icons.schedule),
                  label: Text(S.of(context).schedule),
                  onPressed: () {
                    setState(() {
                      _showProgressIndicator = true;
                    });
                    var tStart = DateTime.now().millisecondsSinceEpoch;
                    _findOptimizedPath().then((response) {
                      var tResponseReceived =
                          DateTime.now().millisecondsSinceEpoch;
                      _parseDistanceMatrixResponse(response);
                      var tResponseParsed =
                          DateTime.now().millisecondsSinceEpoch;
                      _getOptimizedRoute();
                      var tRouteGenerated =
                          DateTime.now().millisecondsSinceEpoch;

                      debugPrint(
                          'Response Delay (ms):${tResponseReceived - tStart}'
                          '\nParse Delay (ms):${tResponseParsed - tResponseReceived}'
                          '\nRoute Optimization (ms):${tRouteGenerated - tResponseParsed}');

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PropertyVisitSchedulingScreen(
                              data: PropertyVisitData(
                                  properties: _propertiesCart,
                                  optimizedPath: _optimizedPath,
                                  selectedPath: _optimizedPath.toList(),
                                  travelMap: _travelMap))));
                    }).whenComplete(() => setState(() {
                          _showProgressIndicator = false;
                        }));
                  })),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Stack(
            children: [
              ListView.builder(
                  // All are -4.0 internal padding
                  padding: const EdgeInsets.only(
                      left: 4.0, right: 4.0, top: 8.0, bottom: 68.0),
                  primary: false,
                  itemCount: _propertiesCart.length,
                  itemBuilder: (context, index) {
                    return PropertyListTile(
                      property: _propertiesCart[index],
                      imageSize: _imageSize,
                      trailing: PropertyListTileTrailingButton(
                        text: S.of(context).save_for_later,
                        icon: Icons.favorite_outline,
                        onTap: () {},
                      ),
                      secondaryTrailing: PropertyListTileTrailingButton(
                        text: S.of(context).remove_property_from_cart,
                        icon: Icons.delete_outline,
                        onTap: () {
                          setState(() {
                            var removedProperty = _propertiesCart[index];
                            _propertiesCart.removeAt(index);
                            _showFab = _propertiesCart.isNotEmpty;
                            _scaffoldMessengerKey.currentState!.showSnackBar(
                                SnackBar(
                                    content: Text(S
                                        .of(context)
                                        .property_has_been_removed),
                                    action: SnackBarAction(
                                        label: S.of(context).undo,
                                        onPressed: () {
                                          setState(() {
                                            _propertiesCart.insert(
                                                index, removedProperty);
                                          });
                                        })));
                          });
                        },
                      ),
                    );
                  }),
              Visibility(
                  visible: _showProgressIndicator,
                  child: LinearProgressIndicator(
                      color: Colors.orangeAccent,
                      backgroundColor: AppTheme.getBackgroundColor(context)))
            ],
          )),
    );
  }

  Future<Response> _findOptimizedPath() async {
    String origins = '';
    for (var element in _propertiesCart) {
      origins += '|${element.address}';
    }
    origins =
        origins.substring(1, origins.length - 1); // remove the starting '|'
    String destinations = origins;

    Uri request = Uri.parse('$distanceMatrixURL'
        '$distanceMatrixResponseFormat?'
        'origins=$origins'
        '&destinations=$destinations'
        '&language=$distanceMatrixResponseLanguage'
        '&key=$distanceMatrixDebugKey');

    debugPrint('request:\n$request');
    return get(request);
  }

  void _parseDistanceMatrixResponse(Response response) {
    // Parse the response into a map of travel times
    if (response.statusCode == 200) {
      Map<String, dynamic> distanceMatrixMap = jsonDecode(response.body);
      DistanceMatrix distanceMatrix =
          DistanceMatrix.fromJson(distanceMatrixMap);
      for (var ori = 0; ori < _propertiesCart.length; ori++) {
        Property origin = _propertiesCart[ori];
        _travelMap[origin] = <Property, int>{};

        for (var dest = 0; dest < _propertiesCart.length; dest++) {
          Property destination = _propertiesCart[dest];
          if (origin != destination) {
            _travelMap[origin]![destination] =
                distanceMatrix.rows[ori].elements[dest].duration.value;
          }
        }
      }
    }
  }

  // The entry point
  void _getOptimizedRoute() {
    _currentPath = [];
    _optimizedPath = [];
    _optimizedTravelTime = -1;

    for (Property origin in _travelMap.keys) {
      _checkTravelTimeFromOrigin(origin, 0);
    }

    var path = '';
    for (var property in _optimizedPath) {
      path += ' ${property.id}';
    }
    debugPrint('Optimized Path:$path');
    debugPrint('Travel Time (seconds): $_optimizedTravelTime');
  }

  // Recursive function
  void _checkTravelTimeFromOrigin(Property origin, culminatedTIme) {
    _currentPath.add(origin);

    if (_currentPath.length == _propertiesCart.length) {
      if (culminatedTIme < _optimizedTravelTime || _optimizedTravelTime == -1) {
        _optimizedTravelTime = culminatedTIme;
        _optimizedPath.clear();
        _optimizedPath.addAll(_currentPath);
      }
    } else {
      Map<Property, int> destinationMap = _travelMap[origin]!;

      destinationMap.forEach((destId, duration) {
        if (!_currentPath.contains(destId)) {
          culminatedTIme += duration;
          _checkTravelTimeFromOrigin(destId, culminatedTIme);
        }
      });
    }
    _currentPath.removeAt(_currentPath.length - 1);
  }
}
