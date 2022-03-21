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
  final _searchBarKey = GlobalKey();
  final double _imageSize = 120.0;
  final List<Property> _propertyList = getSampleProperties();
  final List<String> _suggestions = [
    TextHelper.appLocalizations.hong_kong,
    TextHelper.appLocalizations.kowloon,
    TextHelper.appLocalizations.new_territories
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[

      SliverToBoxAdapter(
          child: SearchBar(
        hintText: TextHelper.appLocalizations.search_properties_hint,
      )),
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
                              image: _propertyList[index].coverImage)),
                      Property.getPropertyPreviewTextWidget(
                          context, _imageSize, _propertyList[index]),
                    ],
                  )),
            );
          },
          childCount: _propertyList.length,
        ),
      )
    ]);

    // return Stack(
    //   children: [
    //     ListView.builder(
    //         // All are -4.0 internal padding
    //         padding: const EdgeInsets.only(
    //             left: 12.0,
    //             right: 12.0,
    //             top: 16.0 + 48.0 + 16.0 - 4.0,
    //             bottom: 4.0),
    //         primary: false,
    //         itemCount: _propertyList.length,
    //         itemBuilder: (context, index) {
    //           return Card(
    //             child: Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     vertical: 8.0, horizontal: 8.0),
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Padding(
    //                         padding: const EdgeInsets.only(right: 16),
    //                         child: Image(
    //                             width: _imageSize,
    //                             height: _imageSize,
    //                             image: _propertyList[index].coverImage)),
    //                     Property.getPropertyPreviewTextWidget(
    //                         context, _imageSize, _propertyList[index]),
    //                   ],
    //                 )),
    //           );
    //         }),
    //     // todo suggestion list here & gradient container should go to search bar class
    //     SearchBar(
    //       hintText: TextHelper.appLocalizations.search_properties_hint,
    //     )
    //   ],
    // );
  }
}
