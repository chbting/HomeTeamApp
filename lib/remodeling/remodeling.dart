import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemodelingScreen extends StatelessWidget {
  const RemodelingScreen({Key? key}) : super(key: key);

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
              tabs: <Widget>[
                Tab(
                  // icon: const Icon(Icons.search),
                  text: AppLocalizations.of(context)!.schedule_remodeling,
                ),
                Tab(
                  // icon: const Icon(Icons.tour),
                  text: AppLocalizations.of(context)!.remodeling_status,
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("New Project"), //TODO
            ),
            Center(
              child: Text("Status"),
            ),
          ],
        ),
      ),
    );
  }
}
