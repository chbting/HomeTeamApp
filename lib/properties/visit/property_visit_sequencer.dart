import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/visit/property_visit_data.dart';
import 'package:tner_client/properties/visit/property_visit_scheduler.dart';
import 'package:tner_client/properties/property_list_tile.dart';
import 'package:tner_client/ui/theme.dart';

class PropertyVisitSequencerWidget extends StatefulWidget {
  const PropertyVisitSequencerWidget(
      {Key? key, required this.data, required this.updateEstimatedTime})
      : super(key: key);

  final PropertyVisitData data;
  final Function updateEstimatedTime;

  @override
  State<PropertyVisitSequencerWidget> createState() =>
      PropertyVisitSequencerWidgetState();
}

class PropertyVisitSequencerWidgetState
    extends State<PropertyVisitSequencerWidget> {
  final double _imageSize = 120.0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.updateEstimatedTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      // note: ListView has 4.0 internal padding on all sides
      padding: const EdgeInsets.only(
          left: 4.0,
          right: 4.0,
          top: PropertyVisitSchedulingScreen.stepTitleBarHeight - 4.0,
          bottom:
              PropertyVisitSchedulingScreen.bottomButtonContainerHeight - 4.0),
      primary: false,
      itemCount: widget.data.selectedPath.length,
      itemBuilder: (context, index) {
        Property property = widget.data.selectedPath[index];
        return PropertyListTile(
          key: ValueKey(property.id),
          property: property,
          imageSize: _imageSize,
          leading: const Icon(Icons.reorder),
          trailing: Text(
            '${widget.data.selectedPath.indexOf(property) + 1}',
            style: AppTheme.getTitleLargeTextStyle(context),
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          Property property = widget.data.selectedPath[oldIndex];
          widget.data.selectedPath.removeAt(oldIndex);
          widget.data.selectedPath
              .insert(newIndex > oldIndex ? newIndex - 1 : newIndex, property);

          widget.updateEstimatedTime();
        });
      },
    );
  }
}
