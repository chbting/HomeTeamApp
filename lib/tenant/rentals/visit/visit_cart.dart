import 'package:flutter/material.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/http_request/distance_matrix_helper.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/theme/theme.dart';
import 'package:hometeam_client/tenant/rentals/rental_list_tile.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_data.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_scheduler.dart';

class VisitCartScreen extends StatefulWidget {
  const VisitCartScreen({Key? key}) : super(key: key);

  @override
  State<VisitCartScreen> createState() => VisitCartScreenState();
}

class VisitCartScreenState extends State<VisitCartScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool _showFab = _listingInCart.isNotEmpty;

  //todo show some messages for user to add items if empty

  final double _imageSize = 120.0;
  final List<Listing> _listingInCart = Debug.getSampleListing().sublist(3, 9);
  Map<Listing, Map<Listing, int>> _travelMap =
      {}; // todo use ID instead of objects Map<originId, Map<destinationId, duration>>
  late List<Listing> _currentPath, _optimizedPath;
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
                      List<Address> addresses = _listingInCart
                          .map((listing) =>
                              PropertyHelper.getFromId(listing.propertyId)
                                  .address)
                          .toList();
                      DistanceMatrixHelper.getMatrix(addresses)
                          .then((response) {
                        var map = DistanceMatrixHelper.parseResponse(
                            response, _listingInCart);
                        if (map != null) {
                          _travelMap = map;
                          _getOptimizedRoute();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VisitSchedulingScreen(
                                  data: VisitData(
                                      listings: _listingInCart,
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
                  itemCount: _listingInCart.length,
                  itemBuilder: (context, index) {
                    return ListingListTile(
                      listing: _listingInCart[index],
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
                            var removedProperty = _listingInCart[index];
                            _listingInCart.removeAt(index);
                            _showFab = _listingInCart.isNotEmpty;
                            _scaffoldMessengerKey.currentState!.showSnackBar(
                                SnackBar(
                                    content: Text(S
                                        .of(context)
                                        .property_has_been_removed),
                                    action: SnackBarAction(
                                        label: S.of(context).undo,
                                        onPressed: () {
                                          setState(() {
                                            _listingInCart.insert(
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

    for (Listing origin in _travelMap.keys) {
      _checkTravelTimeFromOrigin(origin, 0);
    }

    var path = '';
    for (var listing in _optimizedPath) {
      path += ' ${listing.propertyId}';
    }
    debugPrint('Optimized Path:$path');
    debugPrint('Travel Time (seconds): $_optimizedTravelTime');
  }

  // Recursive function
  void _checkTravelTimeFromOrigin(Listing origin, culminatedTIme) {
    _currentPath.add(origin);

    if (_currentPath.length == _listingInCart.length) {
      if (culminatedTIme < _optimizedTravelTime || _optimizedTravelTime == -1) {
        _optimizedTravelTime = culminatedTIme;
        _optimizedPath.clear();
        _optimizedPath.addAll(_currentPath);
      }
    } else {
      Map<Listing, int> destinationMap = _travelMap[origin]!;

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
