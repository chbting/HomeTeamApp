import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';

class RentPropertiesScreen extends StatefulWidget {
  const RentPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<RentPropertiesScreen> createState() => RentPropertiesScreenState();
}

class RentPropertiesScreenState extends State<RentPropertiesScreen> {
  final double _imageSize = 120.0;
  final List<Property> _propertiesInCart = [
    Property(1, "康翠臺", "柴灣", 720, 630, 18400,
        const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
    Property(2, "聚賢居", "上環", 631, 712, 32000,
        const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
    Property(3, "尚翹峰", "柴灣", 601, 520, 24000,
        const AssetImage('assets/demo_images/The_Zenith_240px.jpg')),
    // Property(4, "康翠臺", "柴灣", 720, 630, 18400,
    //     const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
    // Property(5, "聚賢居", "上環", 631, 712, 32000,
    //     const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
    // Property(6, "尚翹峰", "柴灣", 601, 520, 24000,
    //     const AssetImage('assets/demo_images/The_Zenith_240px.jpg')),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        primary: false, // removes status bar padding
        floating: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
            AppLocalizations.of(context)!.properties_visited_last_thirty_days),
        //collapsedHeight: 56.0, //todo min height
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
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
                      // todo changed to check status once offer is submitted, the color should be different as well
                      ElevatedButton(
                          child: Text(
                              AppLocalizations.of(context)!.negotiate_contract),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ContractBrokerScreen(
                                    property: _propertiesInCart[index])));
                          })
                    ],
                  )),
            );
          },
          childCount: _propertiesInCart.length,
        ),
      )
    ]
        // padding: const EdgeInsets.only(
        //     left: 8.0, top: 8.0, right: 8.0, bottom: 72.0),
        );
  }
}
