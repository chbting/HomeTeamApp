import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tner_client/tenant/rentals/property.dart';
import 'package:tner_client/tenant/rentals/rental_list_tile.dart';
import 'package:tner_client/tenant/rentals/visit/visit_data.dart';
import 'package:tner_client/tenant/rentals/visit/visit_scheduler.dart';
import 'package:tner_client/ui/theme.dart';

class VisitSequencerWidget extends StatefulWidget {
  const VisitSequencerWidget(
      {Key? key, required this.data, required this.updateEstimatedTime})
      : super(key: key);

  final VisitData data;
  final Function updateEstimatedTime;

  @override
  State<VisitSequencerWidget> createState() => VisitSequencerWidgetState();
}

class VisitSequencerWidgetState extends State<VisitSequencerWidget> {
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
          top: VisitSchedulingScreen.stepTitleBarHeight - 4.0,
          bottom: VisitSchedulingScreen.bottomButtonContainerHeight - 4.0),
      primary: false,
      itemCount: widget.data.selectedPath.length,
      itemBuilder: (context, index) {
        Property property = widget.data.selectedPath[index];
        return RentalListTile(
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
