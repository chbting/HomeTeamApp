import 'package:flutter/material.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/ui/search_bar.dart';
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
    var list = ListView.builder(
        // All are -4.0 internal padding
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 16.0 + 48.0 + 16.0 - 4.0,
            bottom: 4.0),
        primary: false,
        itemCount: _propertyList.length,
        itemBuilder: (context, index) {
          return Card(
            // todo a sliver pinned search bar will be a better solution since the current search bar is blocking the scrolled to end indicator
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Image(
                            width: _imageSize,
                            height: _imageSize,
                            image: _propertyList[index].coverImage)),
                    Property.getPropertyPreviewTextWidget(
                        context, _imageSize, _propertyList[index]),
                  ],
                )),
          );
        });
    var suggestions = ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Material(
        elevation: 4.0,
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text(_suggestions[index]),
              onTap: () {
                //_setQuery(_suggestions[index]);
                //todo execute search
              },
            );
          },
        ),
      ),
    );

    return CustomScrollView(slivers: <Widget>[
      SliverSearchBar(
        hintText: TextHelper.appLocalizations.search_properties_hint,
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Card(
                margin:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
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
      )
    ]);
  }
}
