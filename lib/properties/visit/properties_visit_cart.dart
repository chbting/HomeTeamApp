import 'package:flutter/material.dart';
import 'package:tner_client/properties/visit/properties_visit_scheduler.dart';
import 'package:tner_client/utils/text_helper.dart';

import '../property.dart';

class PropertiesVisitCartScreen extends StatefulWidget {
  const PropertiesVisitCartScreen({Key? key}) : super(key: key);

  @override
  State<PropertiesVisitCartScreen> createState() =>
      PropertiesVisitCartScreenState();
}

class PropertiesVisitCartScreenState extends State<PropertiesVisitCartScreen>
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
                  label: Text(TextHelper.appLocalizations.schedule),
                  onPressed: () {
                    //todo set distant matrix request here


                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PropertiesVisitSchedulingScreen(
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
                                        content: Text(TextHelper
                                            .appLocalizations
                                            .property_has_been_removed),
                                        action: SnackBarAction(
                                            label: TextHelper
                                                .appLocalizations.undo,
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
