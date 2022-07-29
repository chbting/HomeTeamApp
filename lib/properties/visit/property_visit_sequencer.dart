import 'package:flutter/material.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/visit/property_visit_data.dart';
import 'package:tner_client/properties/visit/property_visit_scheduler.dart';

class PropertyVisitSequencerWidget extends StatefulWidget {
  const PropertyVisitSequencerWidget({Key? key, required this.data})
      : super(key: key);

  final PropertyVisitData data;

  @override
  State<PropertyVisitSequencerWidget> createState() =>
      PropertyVisitSequencerWidgetState();
}

class PropertyVisitSequencerWidgetState
    extends State<PropertyVisitSequencerWidget> {
  final double _imageSize = 120.0;
  int? _selectedId = 0;

  @override
  void initState() {
    super.initState();
    widget.data.startingPropertyId ??= widget.data.propertyList[0].id;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: PropertyVisitSchedulingScreen.stepTitleBarHeight - 4.0,
            bottom: PropertyVisitSchedulingScreen.bottomButtonContainerHeight -
                4.0),
        primary: false,
        itemCount: widget.data.propertyList.length,
        itemBuilder: (context, index) {
          return Property.getPropertyListTile(
              context, _imageSize, widget.data.propertyList[index]);
        });
  }
}
