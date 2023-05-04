import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/theme/theme.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/tenant/rentals/rental_list_tile.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_data.dart';

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
          left: 4.0, right: 4.0, bottom: StandardStepper.buttonBarHeight - 4.0),
      primary: false,
      itemCount: widget.data.selectedPath.length,
      itemBuilder: (context, index) {
        Listing listing = widget.data.selectedPath[index];
        return ListingListTile(
          key: ValueKey(listing.propertyId),
          listing: listing,
          imageSize: _imageSize,
          leading: const Icon(Icons.reorder),
          trailing: Text(
            '${widget.data.selectedPath.indexOf(listing) + 1}',
            style: AppTheme.getTitleLargeTextStyle(context),
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          Listing property = widget.data.selectedPath[oldIndex];
          widget.data.selectedPath.removeAt(oldIndex);
          widget.data.selectedPath
              .insert(newIndex > oldIndex ? newIndex - 1 : newIndex, property);

          widget.updateEstimatedTime();
        });
      },
    );
  }
}
