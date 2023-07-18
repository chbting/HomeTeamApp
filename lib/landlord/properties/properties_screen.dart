import 'package:flutter/material.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/landlord/properties/landlord_property_list_tile.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_uploader.dart';
import 'package:hometeam_client/shared/property_uploader_inherited_data.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

  @override
  State<PropertiesScreen> createState() => PropertiesScreenState();
}

class PropertiesScreenState extends State<PropertiesScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).properties),
            actions: <Widget>[
              IconButton(onPressed: () {}, icon: const Icon(Icons.search))
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            label: Text(S.of(context).add_property),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<bool>(
                      builder: (context) => PropertyUploaderInheritedData.debug( //todo
                          property: Debug.getSampleProperties()[1],
                          //todo property: Property.empty(),
                          child: const PropertyUploader())))
                  .then((uploaded) {
                if (uploaded ?? false) {
                  setState(
                      () {}); //todo wait for thumbnail to be fully processed before loading
                  _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
                    content: Text(S.of(context).property_has_been_uploaded),
                    action: SnackBarAction(
                        label: S.of(context).view,
                        onPressed: () {
                          //todo view property
                        }),
                  ));
                }
              });
            },
          ),
          body: _getPropertyList()),
    );
  }

  Widget _getPropertyList() => FutureBuilder(
      future: PropertyHelper.updateCache(), //todo not updateCache here, but pulled the properties owned by this user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            primary: false,
            itemCount: PropertyHelper.cachedProperties.length,
            itemBuilder: (BuildContext context, int index) {
              return LandlordPropertyListTile(
                property: PropertyHelper.cachedProperties[index],
                onTap: () {
                  //todo view property details
                  debugPrint(PropertyHelper.cachedProperties[index].address
                      .toString());
                },
              );
            },
          );
        } else {
          return const Center(
              child: SizedBox(
                  width: 96.0,
                  height: 96.0,
                  child: CircularProgressIndicator()));
        }
      });
}
