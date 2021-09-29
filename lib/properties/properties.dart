import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: SizedBox(
            height: kToolbarHeight,
            child: TabBar(
              tabs: <Widget>[
                Tab(
                  text: AppLocalizations.of(context)!.find_property,
                ),
                Tab(
                  text: AppLocalizations.of(context)!.visit_properties,
                ),
                Tab(
                  text: AppLocalizations.of(context)!.sign_agreement,
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
            Center(
              child: Text("Sign Agreement"),
            ),
          ],
        ),
      ),
    );
  }
}
