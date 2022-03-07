import 'package:flutter/material.dart';
import 'package:tner_client/utils/text_helper.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextHelper.appLocalizations.agreements),
      ),
      body: Center(
        child: Text(TextHelper.appLocalizations.agreements),
      ),
    );
  }
}
