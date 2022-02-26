import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/properties/visit/properties_visit_scheduler.dart';

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

  final double _imageSize = 120.0;
  final List<Property> _propertiesInCart = [
    Property(1, "康翠臺", "柴灣", 720, 630, 18400,
        const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
    Property(2, "聚賢居", "上環", 631, 712, 32000,
        const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
    Property(3, "尚翹峰", "柴灣", 601, 520, 24000,
        const AssetImage('assets/demo_images/The_Zenith_240px.jpg'))
  ];

  //todo retrieve from local database, local database sync with server on app start

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              heroTag: "properties_visit_cart_fab",
              icon: const Icon(Icons.schedule),
              label: Text(AppLocalizations.of(context)!.schedule),
              onPressed: () {
                _propertiesInCart.isNotEmpty //todo
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PropertiesVisitSchedulingScreen(
                            selectedProperties: _propertiesInCart)))
                    : _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .msg_select_remodeling_item), // todo
                        behavior: SnackBarBehavior.floating,
                      ));
              }),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Image(
                                  width: _imageSize,
                                  height: _imageSize,
                                  image: _propertiesInCart[index].coverImage)),
                          getPropertyPreviewTextWidget(
                              context, _imageSize, _propertiesInCart[index]),
                          SizedBox(
                              height: _imageSize,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // TODO remove item and update list
                                },
                              )),
                        ],
                      )),
                );
              })),
    );
  }
}
