import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/tenant/rentals/listing_list_tile.dart';
import 'package:hometeam_client/tenant/rentals/search/sliver_search_bar.dart';
import 'package:hometeam_client/utils/firebase_path.dart';

class RentalSearchScreen extends StatefulWidget {
  const RentalSearchScreen({Key? key}) : super(key: key);

  @override
  State<RentalSearchScreen> createState() => RentalSearchScreenState();
}

class RentalSearchScreenState extends State<RentalSearchScreen> {
  @override
  Widget build(BuildContext context) {
    List<Listing> listings = Debug.getSampleListing();
    return SliverSearchBar(
      hintText: S.of(context).search_properties_hint,
      onQuerySubmitted: (query) {
        debugPrint('submitted:$query'); //todo
      },
      itemBuilderDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ListingListTile(
              listing: listings[index],
              trailing: RentalListTileTrailingButton(
                  text: S.of(context).property_visit,
                  icon: Icons.check_box_outline_blank,
                  onTap: () {
                    // todo implement checkbox & list add/remove
                  }),
              secondaryTrailing: RentalListTileTrailingButton(
                  text: S.of(context).save,
                  icon: Icons.favorite_outline,
                  onTap: () {
                    // todo implement save to favorites
                  }));
        },
        childCount: listings.length,
      ),
      // todo implement search history
      searchSuggestions: const [],
    );
  }

  Widget _getListings() => FutureBuilder(
      future: _getPropertyList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Property> propertyList = snapshot.data ?? [];
          List<Listing> listings = Debug.propertiesToListings(propertyList);
          return ListView.builder(
            primary: false,
            itemCount: propertyList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListingListTile(
                  listing: listings[index],
                  onTap: () {
                    //todo view property details
                    debugPrint(propertyList[index].address.toString());
                  },
                  trailing: RentalListTileTrailingButton(
                      text: S.of(context).property_visit,
                      icon: Icons.check_box_outline_blank,
                      onTap: () {
                        // todo implement checkbox & list add/remove
                      }),
                  secondaryTrailing: RentalListTileTrailingButton(
                      text: S.of(context).save,
                      icon: Icons.favorite_outline,
                      onTap: () {
                        // todo implement save to favorites
                      }));
            },
          );
        } else {
          return const Center(
              child: SizedBox(
                  width: 96.0,
                  height: 96.0,
                  child: CircularProgressIndicator()));
        }
      });

  Future<List<Property>> _getPropertyList() {
    Completer<List<Property>> completer = Completer();
    FirebaseDatabase.instance
        .ref(FirebasePath.properties)
        .get()
        .then((snapshot) {
      List<Property> propertyList = [];
      if (snapshot.exists) {
        Map<String, dynamic> map = jsonDecode(jsonEncode(snapshot.value));
        map.forEach((key, value) {
          propertyList.add(Property.fromJson(key, value));
        });
      }
      completer.complete(propertyList);
    });
    return completer.future;
  }
}
