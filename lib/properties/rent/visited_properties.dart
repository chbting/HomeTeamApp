import 'package:flutter/material.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';
import 'package:tner_client/utils/text_helper.dart';

class VisitedPropertiesScreen extends StatefulWidget {
  const VisitedPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<VisitedPropertiesScreen> createState() =>
      VisitedPropertiesScreenState();
}

class VisitedPropertiesScreenState extends State<VisitedPropertiesScreen> {
  final double _imageSize = 120.0;
  final List<Property> _propertiesInCart = getSampleProperties();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        primary: false, // removes status bar padding
        floating: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          TextHelper.s.properties_visited_last_thirty_days,
          style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                      // todo changed to check status once offer is submitted, the color should be different as well
                      ElevatedButton(
                          child: Text(
                              TextHelper.s.negotiate_contract),
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
    ]);
  }
}
