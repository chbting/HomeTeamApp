import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RentPropertiesScreen extends StatefulWidget {
  const RentPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<RentPropertiesScreen> createState() => RentPropertiesScreenState();
}

class RentPropertiesScreenState extends State<RentPropertiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.rent_properties);
  }
}
