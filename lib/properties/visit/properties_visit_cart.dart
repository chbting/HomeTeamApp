import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/properties/visit/properties_visit_scheduler.dart';

import '../../theme.dart';
import '../property.dart';

class PropertiesVisitCartScreen extends StatefulWidget {
  const PropertiesVisitCartScreen({Key? key}) : super(key: key);

  @override
  State<PropertiesVisitCartScreen> createState() =>
      PropertiesVisitCartScreenState();
}

class PropertiesVisitCartScreenState
    extends State<PropertiesVisitCartScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static const double imageSize = 120.0;
  final List<Property> _selectedProperties =
      dummyData; //todo retrieve from local database, local database sync with server on app start

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.schedule),
              label: Text(AppLocalizations.of(context)!.schedule),
              onPressed: () {
                _selectedProperties.isNotEmpty //todo
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PropertiesVisitSchedulingScreen(
                            selectedProperties: _selectedProperties)))
                    : _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .msg_select_remodeling_item), // todo
                        behavior: SnackBarBehavior.floating,
                      ));
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: ListView.builder(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 72.0),
              primary: false,
              itemCount: _selectedProperties.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Image(
                              width: imageSize,
                              height: imageSize,
                              image: _selectedProperties[index].coverImage)),
                      Expanded(
                          child: SizedBox(
                        height: imageSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_selectedProperties[index].name!,
                                    style:
                                        Theme.of(context).textTheme.subtitle1!),
                                Text(_selectedProperties[index].district!,
                                    style: AppTheme.getListTileBodyTextStyle(
                                        context))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${AppLocalizations.of(context)!.area_net_abr}'
                                    ': ${_selectedProperties[index].sqFtNet!}'
                                    ' ${AppLocalizations.of(context)!.sq_ft_abr}',
                                    style: AppTheme.getListTileBodyTextStyle(
                                        context)),
                                Text(
                                    '${AppLocalizations.of(context)!.area_gross_abr}'
                                    ': ${_selectedProperties[index].sqFtGross!}'
                                    ' ${AppLocalizations.of(context)!.sq_ft_abr}',
                                    style: AppTheme.getListTileBodyTextStyle(
                                        context))
                              ],
                            ),
                          ],
                        ),
                      )),
                      SizedBox(
                          height: imageSize,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // TODO remove item and update list
                            },
                          )),
                    ],
                  ),
                ));
              })),
    );
  }
}
