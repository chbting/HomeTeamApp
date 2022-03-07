import 'package:flutter/material.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';
import 'package:tner_client/utils/text_helper.dart';

class RentPropertiesScreen extends StatefulWidget {
  const RentPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<RentPropertiesScreen> createState() => RentPropertiesScreenState();
}

class RentPropertiesScreenState extends State<RentPropertiesScreen> {
  final double _imageSize = 120.0;
  final List<Property> _propertiesInCart = Property.getSampleList();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        primary: false, // removes status bar padding
        floating: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          TextHelper.appLocalizations.properties_visited_last_thirty_days,
          style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
        ),
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
                              TextHelper.appLocalizations.negotiate_contract),
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
