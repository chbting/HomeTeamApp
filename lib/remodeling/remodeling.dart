import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/remodeling/remodeling_selections.dart';

class RemodelingScreen extends StatefulWidget {
  const RemodelingScreen({Key? key}) : super(key: key);

  @override
  State<RemodelingScreen> createState() => RemodelingScreenState();
}

class RemodelingScreenState extends State<RemodelingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.remodeling)),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.schedule),
          label: Text(AppLocalizations.of(context)!.schedule_remodeling),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RemodelingOptionsScreen()));
          }),
      body: Center(
        child: Text(AppLocalizations.of(context)!.remodeling_status),
      ),
    );
  }
}
