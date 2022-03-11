import 'package:flutter/material.dart';
import 'package:tner_client/assets/custom_icons_icons.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/utils/text_helper.dart';

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
  final Map<RemodelingItem, String> _titleMap = {};
  final Map<RemodelingItem, IconData> _iconMap = {};
  final List<RemodelingItem> _keyList = [];
  final Map<RemodelingItem, bool> _isSelectedMap = {};

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Rebuild _titleMap every time, in case of language change
    _titleMap[RemodelingItem.painting] =
        getRemodelingItemTitle(RemodelingItem.painting);
    _titleMap[RemodelingItem.wallCoverings] =
        getRemodelingItemTitle(RemodelingItem.wallCoverings);
    _titleMap[RemodelingItem.ac] = getRemodelingItemTitle(RemodelingItem.ac);
    _titleMap[RemodelingItem.removals] =
        getRemodelingItemTitle(RemodelingItem.removals);
    _titleMap[RemodelingItem.suspendedCeiling] =
        getRemodelingItemTitle(RemodelingItem.suspendedCeiling);
    _titleMap[RemodelingItem.toiletReplacement] =
        getRemodelingItemTitle(RemodelingItem.toiletReplacement);
    _titleMap[RemodelingItem.pestControl] =
        getRemodelingItemTitle(RemodelingItem.pestControl);

    // Build only once
    if (_keyList.isEmpty) {
      _keyList.addAll(_titleMap.keys);
      for (var key in _keyList) {
        _isSelectedMap[key] = false;
      }

      _iconMap[RemodelingItem.painting] = Icons.imagesearch_roller;
      _iconMap[RemodelingItem.wallCoverings] = CustomIcons.wallcovering;
      _iconMap[RemodelingItem.ac] = Icons.ac_unit;
      _iconMap[RemodelingItem.removals] = Icons.delete_forever;
      _iconMap[RemodelingItem.suspendedCeiling] = CustomIcons.suspendedCeiling;
      _iconMap[RemodelingItem.toiletReplacement] = CustomIcons.toilet;
      _iconMap[RemodelingItem.pestControl] = Icons.pest_control;
    }

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              heroTag: 'remodelling_selections_fab',
              icon: const Icon(Icons.schedule),
              label: Text(TextHelper.appLocalizations.schedule),
              onPressed: () {
                _isSelectedMap.containsValue(true)
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RemodelingSchedulingScreen(
                            selectionMap: _isSelectedMap)))
                    : _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                        content: Text(TextHelper
                            .appLocalizations.msg_select_remodeling_item),
                        behavior: SnackBarBehavior.floating,
                      ));
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: ListView.builder(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 72.0),
              primary: false,
              itemCount: _keyList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    leading: Icon(_iconMap[_keyList[index]]),
                    title: Text(_titleMap[_keyList[index]]!),
                    trailing: _isSelectedMap[_keyList[index]]!
                        ? Icon(Icons.check_circle,
                            color: Theme.of(context).toggleableActiveColor)
                        : const Icon(Icons.check_circle_outline),
                    onTap: () {
                      setState(() {
                        _isSelectedMap[_keyList[index]] =
                            !_isSelectedMap[_keyList[index]]!;
                      });
                    },
                  ),
                );
              })),
    );
  }
}
