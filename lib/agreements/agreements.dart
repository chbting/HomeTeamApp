import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AgreementsScreen extends StatelessWidget {
  const AgreementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.agreements),
          ),
          body: Center(
            child: Text(AppLocalizations.of(context)!.agreements),
          ),
        ));
  }
}
