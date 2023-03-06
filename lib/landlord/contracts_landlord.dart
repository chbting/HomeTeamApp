import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';

class LandlordContractsScreen extends StatelessWidget {
  const LandlordContractsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.of(context).properties));
  }
}
