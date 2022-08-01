import 'package:flutter/material.dart';
import 'package:tner_client/properties/rent/visited_properties.dart';
import 'package:tner_client/properties/search/properties_search.dart';
import 'package:tner_client/properties/visit/property_visit_cart.dart';
import 'package:tner_client/generated/l10n.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PropertyScreenState();
}

class PropertyScreenState extends State<PropertyScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: SizedBox(
          height: kToolbarHeight,
          child: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                text: S.of(context).find_properties,
              ),
              Tab(
                text: S.of(context).property_visit,
              ),
              Tab(
                text: S.of(context).rent_properties,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          PropertySearchScreen(),
          PropertyVisitCartScreen(),
          VisitedPropertiesScreen(),
        ],
      ),
    );
  }
}
