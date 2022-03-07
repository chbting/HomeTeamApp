import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/properties/rent/rent_properties.dart';
import 'package:tner_client/properties/search/search_properties.dart';
import 'package:tner_client/properties/visit/properties_visit_cart.dart';

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
                  text: AppLocalizations.of(context)!.find_properties,
                ),
                Tab(
                  text: AppLocalizations.of(context)!.properties_visit,
                ),
                Tab(
                  text: AppLocalizations.of(context)!.rent_properties,
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            SearchPropertiesScreen(),
            PropertiesVisitCartScreen(),
            RentPropertiesScreen(),
          ],
        ),
      ),
    );
  }
}
