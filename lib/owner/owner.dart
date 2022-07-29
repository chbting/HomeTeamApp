import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).owner),
          ),
          body: Center(
            child: Text(S.of(context).owner),
          ),
        ));
  }
}
