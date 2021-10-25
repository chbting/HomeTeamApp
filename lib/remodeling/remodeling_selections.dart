import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/assets/custom_icons_icons.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/remodeling_steps.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, String> _titleMap = {};
  final Map<String, IconData> _iconMap = {};
  final List<String> _keyList = [];
  final Map<String, bool> _isSelectedMap = {};

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Rebuild _titleMap every time, in case of language change
    _titleMap[RemodelingItems.paintingKey] =
        RemodelingItems.getRemodelingItemTitle(
            RemodelingItems.paintingKey, context);
    _titleMap[RemodelingItems.wallCoveringsKey] =
        RemodelingItems.getRemodelingItemTitle(
            RemodelingItems.wallCoveringsKey, context);
    _titleMap[RemodelingItems.acInstallationKey] =
        RemodelingItems.getRemodelingItemTitle(
            RemodelingItems.acInstallationKey, context);
    _titleMap[RemodelingItems.removalsKey] =
        RemodelingItems.getRemodelingItemTitle(
            RemodelingItems.removalsKey, context);
    _titleMap[RemodelingItems.suspendedCeilingKey] =
        RemodelingItems.getRemodelingItemTitle(
            RemodelingItems.suspendedCeilingKey, context);
    _titleMap[RemodelingItems.toiletReplacementKey] =
        RemodelingItems.getRemodelingItemTitle(
            RemodelingItems.toiletReplacementKey, context);
    _titleMap[RemodelingItems.pestControlKey] =
        RemodelingItems.getRemodelingItemTitle(
            RemodelingItems.pestControlKey, context);
    // Build only once
    if (_keyList.isEmpty) {
      _keyList.addAll(_titleMap.keys);
      for (var key in _keyList) {
        _isSelectedMap[key] = false;
      }

      _iconMap[RemodelingItems.paintingKey] = Icons.imagesearch_roller;
      _iconMap[RemodelingItems.wallCoveringsKey] = CustomIcons.wallcovering;
      _iconMap[RemodelingItems.acInstallationKey] = Icons.ac_unit;
      _iconMap[RemodelingItems.removalsKey] = Icons.delete_forever;
      _iconMap[RemodelingItems.suspendedCeilingKey] =
          CustomIcons.suspendedCeiling;
      _iconMap[RemodelingItems.toiletReplacementKey] = CustomIcons.toilet;
      _iconMap[RemodelingItems.pestControlKey] = Icons.pest_control;
    }

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.schedule),
              label: Text(AppLocalizations.of(context)!.schedule),
              onPressed: () {
                _isSelectedMap.containsValue(true)
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RemodelingStepsScreen(
                            selectionMap: _isSelectedMap)))
                    : _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .msg_select_remodeling_item),
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
                      setState(() {});
                      _isSelectedMap[_keyList[index]] =
                          !_isSelectedMap[_keyList[index]]!;
                    },
                  ),
                );
              })),
    );
  }
}
