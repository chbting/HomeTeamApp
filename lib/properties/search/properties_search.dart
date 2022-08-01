import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/ui/property_list_tile.dart';
import 'package:tner_client/ui/sliver_search_bar.dart';

class PropertySearchScreen extends StatefulWidget {
  const PropertySearchScreen({Key? key}) : super(key: key);

  @override
  State<PropertySearchScreen> createState() => PropertySearchScreenState();
}

class PropertySearchScreenState extends State<PropertySearchScreen> {
  final double _imageSize = 120.0;
  final List<Property> _propertyList = getSampleProperties();

  @override
  Widget build(BuildContext context) {
    Theme.of(
        context); // This line triggers widget updates when dark/light mode switches
    return SliverSearchBar(
      hintText: S.of(context).search_properties_hint,
      onQuerySubmitted: (query) {
        debugPrint('submitted:$query'); //todo
      },
      itemBuilderDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return PropertyListTile(
              property: _propertyList[index],
              imageSize: _imageSize,
              trailing: PropertyListTileTrailingButton(
                  text: S.of(context).property_visit,
                  icon: Icons.check_box_outline_blank,
                  onTap: () {
                    // todo implement checkbox & list add/remove
                  }),
              secondaryTrailing: PropertyListTileTrailingButton(
                  text: S.of(context).save,
                  icon: Icons.favorite_outline,
                  onTap: () {
                    // todo implement save to favorites
                  }));
        },
        childCount: _propertyList.length,
      ),
      searchSuggestions: [
        S.of(context).hong_kong,
        S.of(context).kowloon,
        S.of(context).new_territories
      ],
    );
  }
}
