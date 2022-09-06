import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_camera.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_inherited_data.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/ui/theme.dart';

class RemodelingImagesWidget extends StatefulWidget {
  const RemodelingImagesWidget({Key? key}) : super(key: key);

  @override
  State<RemodelingImagesWidget> createState() => RemodelingImagesWidgetState();
}

class RemodelingImagesWidgetState extends State<RemodelingImagesWidget> {
  @override
  Widget build(BuildContext context) {
    var info = RemodelingInheritedData.of(context)!.info;
    return ListView.builder(
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: RemodelingScheduler.stepTitleBarHeight - 4.0,
            bottom: RemodelingScheduler.bottomButtonContainerHeight - 4.0),
        primary: false,
        itemCount: info.remodelingItems.length,
        itemBuilder: (context, index) {
          var item = info.remodelingItems[index];
          var pictureRequired = RemodelingItemHelper.isPictureRequired(item);
          var itemImage = info.imageMap[item];
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(RemodelingItemHelper.getIconData(item))]),
              title: Text(RemodelingItemHelper.getItemName(item, context)),
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
                    ? info.imageMap[item] == null
                        ? _openCamera(item)
                        : _showRetakeDialog(context, item)
                    : null;
                // todo if picture is already taken, ask if the user want to retake it
                // todo need a way to cleanup
              },
            ),
          );
        });
  }

  void _openCamera(RemodelingItem item) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => const RemodelingCameraScreen()))
        .then((newImage) {
      if (newImage != null) {
        setState(() {
          RemodelingInheritedData.of(context)!.info.imageMap[item] = newImage;
          RemodelingInheritedData.of(context)!.updateRightButtonState();
        });
      }
    });
  }

  void _showRetakeDialog(BuildContext context, RemodelingItem item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).retake_picture),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).cancel)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openCamera(item);
                },
                child: Text(S.of(context).retake),
              )
            ],
          );
        });
  }
}
