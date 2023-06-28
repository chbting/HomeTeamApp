import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/landlord/properties/landlord_property_list_tile.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_uploader.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';

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
                      builder: (context) => ListingInheritedData(
                          //property: Debug.getSampleProperties()[3],
                          property: Property.empty(),
                          child: const PropertyUploader())))
                  .then((uploaded) {
                if (uploaded ?? false) {
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
          body: getPropertyList()),
    );
  }

  Widget getPropertyList() => FutureBuilder(
      future: _getPropertyList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Property> propertyList = snapshot.data ?? [];
          return ListView.builder(
            primary: false,
            itemCount: propertyList.length,
            itemBuilder: (BuildContext context, int index) {
              return LandlordPropertyListTile(
                property: propertyList[index],
                onTap: () {
                  //todo view property details
                  debugPrint(propertyList[index].address.toString());
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

  Future<List<Property>> _getPropertyList() {
    Completer<List<Property>> completer = Completer();
    FirebaseDatabase.instance.ref('property/').get().then((snapshot) {
      List<Property> propertyList = [];
      if (snapshot.exists) {
        Map<String, dynamic> map = jsonDecode(jsonEncode(snapshot.value));
        map.forEach((key, value) {
          propertyList.add(Property.fromJson(key, value));
        });
      }
      completer.complete(propertyList);
    });
    return completer.future;
  }
}
