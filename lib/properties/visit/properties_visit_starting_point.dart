import 'package:flutter/material.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';

class PropertiesVisitStartingPointWidget extends StatefulWidget {
  const PropertiesVisitStartingPointWidget({Key? key, required this.data})
      : super(key: key);

  final PropertiesVisitData data;

  @override
  State<PropertiesVisitStartingPointWidget> createState() =>
      PropertiesVisitStartingPointWidgetState();
}

class PropertiesVisitStartingPointWidgetState
    extends State<PropertiesVisitStartingPointWidget> {
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
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 72.0),
        primary: false,
        itemCount: widget.data.propertyList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio<int?>(
                        value: widget.data.propertyList[index].id,
                        groupValue: _selectedId,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedId = value;
                          });
                        }),
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 16.0),
                        child: Image(
                            width: _imageSize,
                            height: _imageSize,
                            image: widget.data.propertyList[index].coverImage)),
                    getPropertyPreviewTextWidget(
                        context, _imageSize, widget.data.propertyList[index]),
                  ],
                )),
          );
        });
  }
}
