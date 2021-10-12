import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemodelingItemsScreen extends StatefulWidget {
  const RemodelingItemsScreen({Key? key}) : super(key: key);

  @override
  State<RemodelingItemsScreen> createState() => RemodelingItemsScreenState();
}

class RemodelingItemsScreenState extends State<RemodelingItemsScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(title: Text('step1')),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.arrow_forward),
            label: Text(AppLocalizations.of(context)!.next),
            onPressed: () {
              //TODO
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Text('items'));
  }
}
