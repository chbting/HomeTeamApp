import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/http_request/distance_matrix_helper.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/tenant/rentals/rental_list_tile.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_data.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_scheduler.dart';
import 'package:hometeam_client/ui/theme.dart';

class VisitCartScreen extends StatefulWidget {
  const VisitCartScreen({Key? key}) : super(key: key);

  @override
  State<VisitCartScreen> createState() => VisitCartScreenState();
}

class VisitCartScreenState extends State<VisitCartScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool _showFab = _propertiesCart.isNotEmpty;

  //todo show some messages for user to add items if empty

  final double _imageSize = 120.0;
  final List<Property> _propertiesCart = getSampleProperties().sublist(3, 9);
  Map<Property, Map<Property, int>> _travelMap =
      {}; // todo use ID instead of objects Map<originId, Map<destinationId, duration>>
  late List<Property> _currentPath, _optimizedPath;
  late int _optimizedTravelTime;
  bool _showProgressIndicator = false;
  bool _fabEnabled = true;

  @override
  Widget build(BuildContext context) {
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
                    // Do no action if a request is in progress
                    if (_fabEnabled) {
                      setState(() {
                        _fabEnabled = false;
                        _showProgressIndicator = true;
                      });
                      List<Address> addresses =
                          _propertiesCart.map((e) => e.address).toList();
                      DistanceMatrixHelper.getMatrix(addresses)
                          .then((response) {
                        var map =
                            DistanceMatrixHelper.parseDistanceMatrixResponse(
                                response, _propertiesCart);
                        if (map != null) {
                          _travelMap = map;
                          _getOptimizedRoute();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VisitSchedulingScreen(
                                  data: VisitData(
                                      properties: _propertiesCart,
                                      optimizedPath: _optimizedPath,
                                      selectedPath: _optimizedPath.toList(),
                                      travelMap: _travelMap))));
                        } else {
                          _scaffoldMessengerKey.currentState!.showSnackBar(
                              SnackBar(
                                  content: Text(S
                                      .of(context)
                                      .msg_failed_to_generate_visit_path)));
                        }
                      }).whenComplete(() => setState(() {
                                _showProgressIndicator = false;
                                _fabEnabled = true;
                              }));
                    }
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
                    return RentalListTile(
                      property: _propertiesCart[index],
                      imageSize: _imageSize,
                      trailing: RentalListTileTrailingButton(
                        text: S.of(context).save_for_later,
                        icon: Icons.favorite_outline,
                        onTap: () {},
                      ),
                      secondaryTrailing: RentalListTileTrailingButton(
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
