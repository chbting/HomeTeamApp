import 'package:flutter/material.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/bid.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker_inherited_data.dart';
import 'package:hometeam_client/tenant/rentals/listing_list_tile.dart';

class VisitedPropertiesScreen extends StatefulWidget {
  const VisitedPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<VisitedPropertiesScreen> createState() =>
      VisitedPropertiesScreenState();
}

class VisitedPropertiesScreenState extends State<VisitedPropertiesScreen> {
  final double _imageSize = 120.0;
  final List<Listing> _listingInCart = Debug.getSampleListing();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        primary: false, // removes status bar padding
        floating: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          S.of(context).properties_visited_last_thirty_days,
          style:
              TextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ListingListTile(
                listing: _listingInCart[index],
                imageSize: _imageSize,
                trailing: RentalListTileTrailingButton(
                    text: S.of(context).negotiate_contract,
                    icon: Icons.description_outlined,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContractBrokerInheritedData(
                              bid: Bid(
                                  listingId: _listingInCart[index].id,
                                  biddingTerms: Terms(
                                      propertyId:
                                          _listingInCart[index].propertyId)),
                              child: const ContractBrokerScreen())));
                    }));
          },
          childCount: _listingInCart.length,
        ),
      )
    ]);
  }
}
