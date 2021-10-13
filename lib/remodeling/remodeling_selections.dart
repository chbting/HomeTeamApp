import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/assets/custom_icons_icons.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';

class RemodelingOptionsScreen extends StatefulWidget {
  const RemodelingOptionsScreen({Key? key}) : super(key: key);

  @override
  State<RemodelingOptionsScreen> createState() =>
      RemodelingSelectionsScreenState();
}

class RemodelingSelectionsScreenState extends State<RemodelingOptionsScreen>
    with AutomaticKeepAliveClientMixin {
  final Map<IconData, String> _itemMap = {};
  final List<IconData> _keyList = [];
  final Map<IconData, bool> _isSelectedMap = {};

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Rebuild _itemMap every time, in case of language change
    _itemMap[Icons.imagesearch_roller] = AppLocalizations.of(context)!.painting;
    _itemMap[CustomIcons.wallcovering] =
        AppLocalizations.of(context)!.wallcoverings;
    _itemMap[Icons.ac_unit] = AppLocalizations.of(context)!.ac_installation;
    _itemMap[Icons.delete_forever] = AppLocalizations.of(context)!.removals;
    _itemMap[CustomIcons.suspendedCeiling] =
        AppLocalizations.of(context)!.suspended_ceiling;
    _itemMap[CustomIcons.toilet] =
        AppLocalizations.of(context)!.toilet_replacement;
    _itemMap[Icons.pest_control] = AppLocalizations.of(context)!.pest_control;

    // Build _isSelectedMap only once
    if (_keyList.isEmpty) {
      _keyList.addAll(_itemMap.keys);
      for (var key in _keyList) {
        _isSelectedMap[key] = false;
      }
    }
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.schedule),
              label: Text(AppLocalizations.of(context)!.schedule),
              onPressed: () {
                _isSelectedMap.containsValue(true)
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RemodelingItemsScreen()))
                    : scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
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
                    leading: Icon(_keyList[index]),
                    title: Text(_itemMap[_keyList[index]]!),
                    trailing: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        child: _isSelectedMap[_keyList[index]]!
                            ? Icon(Icons.check_circle,
                                color: Theme.of(context).toggleableActiveColor)
                            : const Icon(Icons.check_circle_outline)),
                    // TODO animation
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
