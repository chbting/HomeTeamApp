import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/tenant/rentals/property.dart';
import 'package:tner_client/tenant/rentals/rental_list_tile.dart';
import 'package:tner_client/tenant/rentals/search/sliver_search_bar.dart';

class RentalSearchScreen extends StatefulWidget {
  const RentalSearchScreen({Key? key}) : super(key: key);

  @override
  State<RentalSearchScreen> createState() => RentalSearchScreenState();
}

class RentalSearchScreenState extends State<RentalSearchScreen> {
  final double _imageSize = 120.0;
  final List<Property> _propertyList = getSampleProperties();

  @override
  Widget build(BuildContext context) {
    return SliverSearchBar(
      hintText: S.of(context).search_properties_hint,
      onQuerySubmitted: (query) {
        debugPrint('submitted:$query'); //todo
      },
      itemBuilderDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return RentalListTile(
              property: _propertyList[index],
              imageSize: _imageSize,
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
        childCount: _propertyList.length,
      ),
      // todo implement search history
      searchSuggestions: const [],
    );
  }
}
