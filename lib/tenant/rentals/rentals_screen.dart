import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/tenant/rentals/rent/visited_properties.dart';
import 'package:hometeam_client/tenant/rentals/search/rental_search.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_cart.dart';

class RentalsScreen extends StatefulWidget {
  const RentalsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RentalsScreenState();
}

class RentalsScreenState extends State<RentalsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Close the keyboard
        FocusManager.instance.primaryFocus?.unfocus();
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
          RentalSearchScreen(),
          VisitCartScreen(),
          VisitedPropertiesScreen(),
        ],
      ),
    );
  }
}
