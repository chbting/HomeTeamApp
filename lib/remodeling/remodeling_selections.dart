import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_info.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_inherited_data.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';

class RemodelingSelectionsScreen extends StatefulWidget {
  const RemodelingSelectionsScreen({Key? key}) : super(key: key);

  @override
  State<RemodelingSelectionsScreen> createState() =>
      RemodelingSelectionsScreenState();
}

class RemodelingSelectionsScreenState extends State<RemodelingSelectionsScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<RemodelingItem> _itemList = [
    RemodelingItem.painting,
    RemodelingItem.wallCoverings,
    RemodelingItem.ac,
    RemodelingItem.removals,
    RemodelingItem.suspendedCeiling,
    RemodelingItem.toiletReplacement,
    RemodelingItem.pestControl
  ];
  final Map<RemodelingItem, bool> _selectionMap = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    for (var item in _itemList) {
      _selectionMap[item] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              heroTag: 'remodelling_selections_fab',
              icon: const Icon(Icons.schedule),
              label: Text(S.of(context).schedule),
              onPressed: () {
                if (_selectionMap.containsValue(true)) {
                  List<RemodelingItem> remodelingItems = [];
                  _selectionMap.forEach((remodelingItem, selected) {
                    if (selected) {
                      remodelingItems.add(remodelingItem);
                    }
                  });

                  var info = RemodelingInfo(remodelingItems: remodelingItems);
                  var uiState = RemodelingSchedulerUIState(
                      showBottomButtons: ValueNotifier(
                          remodelingItems.length == 1 ? true : false));

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RemodelingInheritedData(
                          info: info,
                          uiState: uiState,
                          child: const RemodelingScheduler())));
                } else {
                  _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                    content: Text(S.of(context).msg_select_remodeling_item),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: ListView.builder(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 72.0),
              primary: false,
              itemCount: _itemList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    leading: Icon(
                        RemodelingItemHelper.getIconData(_itemList[index])),
                    title: Text(RemodelingItemHelper.getItemName(
                        _itemList[index], context)),
                    trailing: _selectionMap[_itemList[index]]!
                        ? Icon(Icons.check_circle,
                            color: Theme.of(context).toggleableActiveColor)
                        : const Icon(Icons.check_circle_outline),
                    onTap: () {
                      setState(() {
                        _selectionMap[_itemList[index]] =
                            !_selectionMap[_itemList[index]]!;
                      });
                    },
                  ),
                );
              })),
    );
  }
}
