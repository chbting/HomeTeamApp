import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
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
  final List<Property> _propertyList = getSampleProperties();

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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListingInheritedData(
                      property: Property.empty(),
                      child: const PropertyUploader())));
            },
          ),
          body: ListView.builder(
            primary: false,
            itemCount: _propertyList.length,
            itemBuilder: (BuildContext context, int index) {
              return LandlordPropertyListTile(
                property: _propertyList[index],
                onTap: () {
                  //todo
                  debugPrint(_propertyList[index].address.toString());
                },
              );
            },
          )),
    );
  }
}
