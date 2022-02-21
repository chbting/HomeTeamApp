import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/properties/visit/properties_visit_scheduler.dart';

import '../property.dart';

class PropertiesVisitSelectionScreen extends StatefulWidget {
  const PropertiesVisitSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PropertiesVisitSelectionScreen> createState() =>
      PropertiesVisitSelectionScreenState();
}

class PropertiesVisitSelectionScreenState
    extends State<PropertiesVisitSelectionScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final List<Property> _selectedProperties = []; //todo retrieve from?

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.schedule),
              label: Text(AppLocalizations.of(context)!.schedule),
              onPressed: () {
                _selectedProperties.isNotEmpty //todo
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PropertiesVisitSchedulingScreen(
                            selectedProperties: _selectedProperties)))
                    : _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .msg_select_remodeling_item), // todo
                        behavior: SnackBarBehavior.floating,
                      ));
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: ListView.builder(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 72.0),
              primary: false,
              itemCount: _selectedProperties.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    // leading: todo image
                    title: Text(_selectedProperties[index].name!),
                    trailing: const Icon(Icons.delete),
                    onTap: () {
                      //todo show property details
                    },
                  ),
                );
              })),
    );
  }
}
