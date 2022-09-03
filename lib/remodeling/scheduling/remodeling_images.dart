import 'package:flutter/material.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_camera.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';

class RemodellingImagesWidget extends StatefulWidget {
  const RemodellingImagesWidget({Key? key, required this.data})
      : super(key: key);

  final RemodelingSchedulingData data;

  @override
  State<RemodellingImagesWidget> createState() =>
      RemodellingImagesWidgetState();
}

class RemodellingImagesWidgetState extends State<RemodellingImagesWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //todo needed?

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: RemodelingSchedulingScreen.stepTitleBarHeight - 4.0,
            bottom:
                RemodelingSchedulingScreen.bottomButtonContainerHeight - 4.0),
        primary: false,
        itemCount: widget.data.selectedItemList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              leading: Icon(RemodelingItemHelper.getIconData(
                  widget.data.selectedItemList[index])),
              title: Text(RemodelingItemHelper.getTitle(
                  widget.data.selectedItemList[index], context)),
              trailing:
                  widget.data.imageMap[widget.data.selectedItemList[index]] ==
                          null
                      ? const Icon(Icons.add_circle)
                      : Icon(Icons.check_circle,
                          color: Theme.of(context).toggleableActiveColor),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const RemodelingCameraScreen()))
                    .then((image) => setState(() {
                          widget.data.imageMap[
                              widget.data.selectedItemList[index]] = image;
                        }));
                // todo need a callback to save the image path
                // todo need a way to cleanup
                // todo grey out next button until all pictures are taken
              },
            ),
          );
        });
  }
}
