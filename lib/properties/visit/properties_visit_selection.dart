import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PropertiesVisitSelectionScreen extends StatefulWidget {
  const PropertiesVisitSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PropertiesVisitSelectionScreen> createState() => PropertiesVisitSelectionScreenState();
}

class PropertiesVisitSelectionScreenState extends State<PropertiesVisitSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.visit_properties),
    );
  }
}
