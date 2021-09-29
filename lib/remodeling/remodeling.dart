import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/remodeling/remodeling_scheduling_tab.dart';

class RemodelingScreen extends StatefulWidget {
  const RemodelingScreen({Key? key}) : super(key: key);

  @override
  State<RemodelingScreen> createState() => RemodelingScreenState();
}

class RemodelingScreenState extends State<RemodelingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // TODO
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: SizedBox(
            height: kToolbarHeight,
            child: TabBar(
              tabs: <Widget>[
                Tab(
                  text: AppLocalizations.of(context)!.schedule_remodeling,
                ),
                Tab(
                  text: AppLocalizations.of(context)!.remodeling_status,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            const RemodelingSchedulingTab(),
            Center(
              child: Text(AppLocalizations.of(context)!.remodeling_status),
            ),
          ],
        ),
      ),
    );
  }
}
