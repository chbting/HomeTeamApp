import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/tenant/rentals/property.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/tenant/rentals/rental_list_tile.dart';

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
          S.of(context).properties_visited_last_thirty_days,
          style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return RentalListTile(
                property: _propertiesInCart[index],
                imageSize: _imageSize,
                trailing: RentalListTileTrailingButton(
                    text: S.of(context).negotiate_contract,
                    icon: Icons.description_outlined,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContractBrokerScreen(
                              property: _propertiesInCart[index])));
                    }));
          },
          childCount: _propertiesInCart.length,
        ),
      )
    ]);
  }
}
