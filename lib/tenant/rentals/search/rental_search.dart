import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/tenant/rentals/listing_list_tile.dart';
import 'package:hometeam_client/tenant/rentals/search/sliver_search.dart';
import 'package:hometeam_client/utils/firebase_path.dart';

class RentalSearchScreen extends StatefulWidget {
  const RentalSearchScreen({Key? key}) : super(key: key);

  @override
  State<RentalSearchScreen> createState() => RentalSearchScreenState();
}

class RentalSearchScreenState extends State<RentalSearchScreen> {
  List<Listing> listings = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getListings()
          .then((listings) => setState(() => this.listings = listings));
    });
  }

  @override
  Widget build(BuildContext context) {
    // todo implement search history
    final List<String> sampleSuggestions = [
      S.of(context).hong_kong,
      S.of(context).kowloon,
      S.of(context).new_territories
    ];

    debugPrint('$listings');
    return SliverSearch(
      onRefresh: _onRefresh,
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
      hintText: S.of(context).search_properties_hint,
      searchSuggestions: sampleSuggestions,
    );
  }

  Future<void> _onRefresh() async {
    //todo
    return Future.delayed(const Duration(seconds: 2));
  }

  Future<List<Listing>> _getListings() {
    Completer<List<Listing>> completer = Completer();
    // todo should be pulling from a listing table instead
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
      completer.complete(Debug.propertiesToListings(propertyList));//todo
    });
    return completer.future;
  }
}
