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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(
            left: 8.0, top: 8.0, right: 8.0, bottom: 72.0),
        primary: false,
        itemCount: widget.data.propertyList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //todo add a radio button
                    Padding(
                        padding: const EdgeInsets.only(left:16, right: 16),
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
