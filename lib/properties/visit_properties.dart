import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VisitPropertiesScreen extends StatefulWidget {
  const VisitPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<VisitPropertiesScreen> createState() => VisitPropertiesScreenState();
}

class VisitPropertiesScreenState extends State<VisitPropertiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.visit_properties);
  }
}
