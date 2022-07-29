import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/properties/visit/property_visit_scheduler.dart';
import 'package:tner_client/ui/theme.dart';

import '../property.dart';

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
  late bool _showFab = _propertiesInCart
      .isNotEmpty; //todo show some messages for user to add items if empty

  final double _imageSize = 120.0;
  final List<Property> _propertiesInCart = getSampleProperties();

  //todo retrieve from local database, local database sync with server on app start

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
                    //todo set distant matrix request here


                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PropertyVisitSchedulingScreen(
                            selectedProperties: _propertiesInCart)));
                  })),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: ListView.builder(
              // All are -4.0 internal padding
              padding: const EdgeInsets.only(
                  left: 4.0, right: 4.0, top: 4.0, bottom: 68.0),
              primary: false,
              itemCount: _propertiesInCart.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Image(
                                  width: _imageSize,
                                  height: _imageSize,
                                  image: _propertiesInCart[index].coverImage)),
                          Property.getPropertyPreviewTextWidget(
                              context, _imageSize, _propertiesInCart[index]),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                var removedProperty = _propertiesInCart[index];
                                _propertiesInCart.removeAt(index);
                                _showFab = _propertiesInCart.isNotEmpty;
                                _scaffoldMessengerKey.currentState!
                                    .showSnackBar(SnackBar(
                                        content: Text(S.of(context)
                                            .property_has_been_removed),
                                        action: SnackBarAction(
                                            label: S.of(context).undo,
                                            onPressed: () {
                                              setState(() {
                                                _propertiesInCart.insert(
                                                    index, removedProperty);
                                              });
                                            })));
                              });
                            },
                          )
                        ],
                      )),
                );
              })),
    );
  }
}