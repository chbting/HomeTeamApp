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
  final List<Property> _propertiesInCart = Property.getSampleList();

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
                    _propertiesInCart.isNotEmpty
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PropertiesVisitSchedulingScreen(
                                    selectedProperties: _propertiesInCart)))
                        : _scaffoldMessengerKey.currentState!
                            .showSnackBar(SnackBar(
                            content: Text(TextHelper.appLocalizations
                                .msg_select_remodeling_item), // todo
                            behavior: SnackBarBehavior.floating,
                          ));
                  })),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: ListView.builder(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 72.0),
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
                          getPropertyPreviewTextWidget(
                              context, _imageSize, _propertiesInCart[index]),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              var removedProperty = _propertiesInCart[index];
                              _propertiesInCart.removeAt(index);
                              _showFab = _propertiesInCart.isNotEmpty;
                              _scaffoldMessengerKey.currentState!.showSnackBar(
                                  SnackBar(
                                      content: Text(TextHelper.appLocalizations
                                          .property_has_been_removed),
                                      action: SnackBarAction(
                                          label:
                                              TextHelper.appLocalizations.undo,
                                          onPressed: () {
                                            _propertiesInCart.insert(
                                                index, removedProperty);
                                            setState(() {});
                                          })));
                              setState(() {});
                            },
                          )
                        ],
                      )),
                );
              })),
    );
  }
}
