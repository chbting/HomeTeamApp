import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/assets/custom_icons_icons.dart';

class RemodelingSchedulingTab extends StatefulWidget {
  const RemodelingSchedulingTab({Key? key}) : super(key: key);

  @override
  State<RemodelingSchedulingTab> createState() =>
      RemodelingSchedulingTabState();
}

class RemodelingSchedulingTabState extends State<RemodelingSchedulingTab>
    with AutomaticKeepAliveClientMixin {
  final Map<IconData, String> _itemMap = {};
  final List<IconData> _keyList = [];
  List<bool> _isSelectedList = [];

  @override
  bool get wantKeepAlive => true;

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
      _isSelectedList = List.generate(_keyList.length, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.schedule),
          label: Text(AppLocalizations.of(context)!.schedule_remodeling),
          onPressed: () {
            // TODO to scheduling step
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            primary: false, // TODO bottom padding
            itemCount: _keyList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(_keyList[index]),
                  title: Text(_itemMap[_keyList[index]]!),
                  trailing: _isSelectedList[index]
                      ? Icon(Icons.check_circle,
                          color: Theme.of(context).toggleableActiveColor)
                      : const Icon(Icons.check_circle_outline),
                  onTap: () {
                    setState(() {});
                    _isSelectedList[index] = !_isSelectedList[index];
                  },
                ),
              );
            }));
  }
}
