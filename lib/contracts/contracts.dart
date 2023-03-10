import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).contracts),
      ),
      body: Center(
        child: Text(S.of(context).contracts),
      ),
    );
  }
}
