import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/assets/custom_icons_icons.dart';

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

  //
  // @override
  // void didUpdateWidget() {
  //
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _itemMap[Icons.imagesearch_roller] =
          AppLocalizations.of(context)!.painting;
      _itemMap[CustomIcons.wallcovering] =
          AppLocalizations.of(context)!.wallcoverings;
      _itemMap[Icons.ac_unit] = AppLocalizations.of(context)!.ac_installation;
      _itemMap[Icons.delete_forever] = AppLocalizations.of(context)!.removal;
      _itemMap[CustomIcons.suspendedCeiling] =
          AppLocalizations.of(context)!.suspended_ceiling;
      _itemMap[CustomIcons.toilet] =
          AppLocalizations.of(context)!.toilet_replacement;
      _itemMap[Icons.pest_control] = AppLocalizations.of(context)!.pest_control;

      _keyList.addAll(_itemMap.keys);
      for (var key in _keyList) {
        _isSelectedMap[key] = false;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.schedule_remodeling)),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.arrow_forward),
            label: Text(AppLocalizations.of(context)!.next),
            onPressed: () {
              // TODO
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            }));
  }
}
