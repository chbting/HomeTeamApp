import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';

import 'remodeling_selections.dart';
import 'remodeling_status.dart';

class RemodelingScreen extends StatelessWidget {
  const RemodelingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: SizedBox(
            height: kToolbarHeight,
            child: TabBar(
              tabs: <Widget>[
                Tab(
                  text: S.of(context).schedule_remodeling,
                ),
                Tab(
                  text: S.of(context).remodeling_status,
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            RemodelingSelectionsScreen(),
            RemodelingStatusScreen(),
          ],
        ),
      ),
    );
  }
}
