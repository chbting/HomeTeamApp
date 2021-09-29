import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: SizedBox(
            height: kToolbarHeight,
            child: TabBar(
              // TODO indicatorColor:
              tabs: <Widget>[
                Tab(
                  // icon: const Icon(Icons.search),
                  text: AppLocalizations.of(context)!.search,
                ),
                Tab(
                  // icon: const Icon(Icons.tour),
                  text: AppLocalizations.of(context)!.visit_properties,
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("Search"), //TODO
            ),
            Center(
              child: Text("Visit"),
            ),
          ],
        ),
      ),
    );
  }
}
