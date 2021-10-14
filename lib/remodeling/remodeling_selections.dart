import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/assets/custom_icons_icons.dart';
import 'package:tner_client/remodeling/remodeling_options.dart';

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
    _titleMap[RemodelingOptions.paintingKey] =
        AppLocalizations.of(context)!.painting;
    _titleMap[RemodelingOptions.wallCoveringsKey] =
        AppLocalizations.of(context)!.wallcoverings;
    _titleMap[RemodelingOptions.acInstallationKey] =
        AppLocalizations.of(context)!.ac_installation;
    _titleMap[RemodelingOptions.removalsKey] =
        AppLocalizations.of(context)!.removals;
    _titleMap[RemodelingOptions.suspendedCeilingKey] =
        AppLocalizations.of(context)!.suspended_ceiling;
    _titleMap[RemodelingOptions.toiletReplacementKey] =
        AppLocalizations.of(context)!.toilet_replacement;
    _titleMap[RemodelingOptions.pestControlKey] =
        AppLocalizations.of(context)!.pest_control;

    // Build only once
    if (_keyList.isEmpty) {
      _keyList.addAll(_titleMap.keys);
      for (var key in _keyList) {
        _isSelectedMap[key] = false;
      }

      _iconMap[RemodelingOptions.paintingKey] = Icons.imagesearch_roller;
      _iconMap[RemodelingOptions.wallCoveringsKey] = CustomIcons.wallcovering;
      _iconMap[RemodelingOptions.acInstallationKey] = Icons.ac_unit;
      _iconMap[RemodelingOptions.removalsKey] = Icons.delete_forever;
      _iconMap[RemodelingOptions.suspendedCeilingKey] =
          CustomIcons.suspendedCeiling;
      _iconMap[RemodelingOptions.toiletReplacementKey] = CustomIcons.toilet;
      _iconMap[RemodelingOptions.pestControlKey] = Icons.pest_control;
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
                        builder: (context) => RemodelingOptionsScreen(
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

class RemodelingOptions {
  static const String paintingKey = 'painting';
  static const String wallCoveringsKey = 'wallCoverings';
  static const String acInstallationKey = 'acInstallation';
  static const String removalsKey = 'removals';
  static const String suspendedCeilingKey = 'suspendedCeiling';
  static const String toiletReplacementKey = 'toiletReplacement';
  static const String pestControlKey = 'pestControl';
}
