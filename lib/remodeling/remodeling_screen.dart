import 'package:flutter/material.dart';
import 'package:tner_client/remodeling/remodeling_status.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_selections.dart';
import 'package:tner_client/utils/text_helper.dart';

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
                  text: TextHelper.s.schedule_remodeling,
                ),
                Tab(
                  text: TextHelper.s.remodeling_status,
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
