import 'package:flutter/material.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/ui/sliver_search_bar.dart';
import 'package:tner_client/utils/text_helper.dart';

class SearchPropertiesScreen extends StatefulWidget {
  const SearchPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPropertiesScreen> createState() => SearchPropertiesScreenState();
}

class SearchPropertiesScreenState extends State<SearchPropertiesScreen> {
  final double _imageSize = 120.0;
  final List<Property> _propertyList = getSampleProperties();
  final List<String> _suggestions = [
    TextHelper.appLocalizations.hong_kong,
    TextHelper.appLocalizations.kowloon,
    TextHelper.appLocalizations.new_territories
  ];

  @override
  Widget build(BuildContext context) {
    return SliverSearchBar(
      hintText: TextHelper.appLocalizations.search_properties_hint,
      itemBuilderDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Card(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Image(
                              width: _imageSize,
                              height: _imageSize,
                              image: _propertyList[index].coverImage)),
                      Property.getPropertyPreviewTextWidget(
                          context, _imageSize, _propertyList[index]),
                    ],
                  )));
        },
        childCount: _propertyList.length,
      ),
      searchSuggestions: _suggestions,
    );
  }
}
