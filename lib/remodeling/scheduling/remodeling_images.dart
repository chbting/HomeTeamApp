import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_camera.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/ui/theme.dart';

class RemodellingImagesWidget extends StatefulWidget {
  const RemodellingImagesWidget({Key? key, required this.data})
      : super(key: key);

  final RemodelingSchedulingData data;

  @override
  State<RemodellingImagesWidget> createState() =>
      RemodellingImagesWidgetState();
}

class RemodellingImagesWidgetState extends State<RemodellingImagesWidget> {
  @override
  Widget build(BuildContext context) {
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
          var item = widget.data.selectedItemList[index];
          var pictureRequired = RemodelingItemHelper.isPictureRequired(item);
          var itemImage = widget.data.imageMap[item];
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(RemodelingItemHelper.getIconData(item))]),
              title: Text(RemodelingItemHelper.getTitle(item, context)),
              subtitle: Text(
                  pictureRequired
                      ? itemImage == null
                          ? S.of(context).picture_required
                          : S.of(context).picture_added
                      : S.of(context).picture_not_required,
                  style: AppTheme.getListTileBodyTextStyle(context)),
              trailing: pictureRequired
                  ? itemImage == null
                      ? const Icon(Icons.add_circle)
                      : Icon(Icons.check_circle,
                          color: Theme.of(context).toggleableActiveColor)
                  : Icon(Icons.check_circle,
                      color: Theme.of(context).toggleableActiveColor),
              onTap: () {
                pictureRequired
                    ? Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) =>
                                const RemodelingCameraScreen()))
                        .then((newImage) => setState(() {
                              if (newImage != null) {
                                widget.data.imageMap[item] = newImage;
                              }
                            }))
                    : null;
                // todo need a way to cleanup
              },
            ),
          );
        });
  }
}
