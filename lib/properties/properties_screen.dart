import 'package:flutter/material.dart';
import 'package:tner_client/properties/rent/visited_properties.dart';
import 'package:tner_client/properties/search/search_properties.dart';
import 'package:tner_client/properties/search/search_properties_old.dart';
import 'package:tner_client/properties/visit/properties_visit_cart.dart';
import 'package:tner_client/utils/text_helper.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: SizedBox(
            height: kToolbarHeight,
            child: TabBar(
              tabs: <Widget>[
                Tab(
                  text: TextHelper.appLocalizations.find_properties,
                ),
                Tab(
                  text: TextHelper.appLocalizations.properties_visit,
                ),
                Tab(
                  text: TextHelper.appLocalizations.rent_properties,
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            SearchPropertiesScreen(),
            SearchPropertiesScreenOld(),
            //PropertiesVisitCartScreen(), //todo
            VisitedPropertiesScreen(),
          ],
        ),
      ),
    );
  }
}
