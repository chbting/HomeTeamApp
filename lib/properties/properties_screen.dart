import 'package:flutter/material.dart';
import 'package:tner_client/properties/rent/visited_properties.dart';
import 'package:tner_client/properties/search/search_properties.dart';
import 'package:tner_client/properties/visit/properties_visit_cart.dart';
import 'package:tner_client/utils/text_helper.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PropertiesScreenState();
}

class PropertiesScreenState extends State<PropertiesScreen>
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
                text: TextHelper.s.find_properties,
              ),
              Tab(
                text: TextHelper.s.properties_visit,
              ),
              Tab(
                text: TextHelper.s.rent_properties,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          SearchPropertiesScreen(),
          PropertiesVisitCartScreen(),
          VisitedPropertiesScreen(),
        ],
      ),
    );
  }
}
