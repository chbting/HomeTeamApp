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
  final _gridviewSpacing = 8.0;

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
          var imageList = info.imageMap[item]!;
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              leading: Icon(RemodelingItemHelper.getIconData(item)),
              title: Text(RemodelingItemHelper.getItemName(item, context)),
              subtitle: pictureRequired
                  ? imageList.isEmpty
                      ? Text(S.of(context).picture_required,
                          style: AppTheme.getListTileBodyTextStyle(context))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(S.of(context).picture_taken,
                                    style: AppTheme.getListTileBodyTextStyle(
                                        context))),
                            GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: _gridviewSpacing,
                                        crossAxisSpacing: _gridviewSpacing),
                                itemCount: imageList.length,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return Ink.image(
                                      image: FileImage(imageList[index]),
                                      fit: BoxFit.cover,
                                      child: InkWell(onTap: () {
                                        debugPrint(
                                            '$index'); // todo open image, probably in a dialog /w option to retake this and retake all images
                                      }));
                                })
                          ],
                        )
                  : Text(S.of(context).picture_not_required,
                      style: AppTheme.getListTileBodyTextStyle(context)),
              trailing: pictureRequired
                  ? imageList.isEmpty
                      ? const Icon(Icons.add_circle)
                      : Icon(Icons.check_circle,
                          color: Theme.of(context).toggleableActiveColor)
                  : Icon(Icons.check_circle,
                      color: Theme.of(context).toggleableActiveColor),
              onTap: pictureRequired
                  ? imageList.isEmpty
                      ? () {
                          _openCamera(item);
                        }
                      : null
                  : null,
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
          RemodelingInheritedData.of(context)!
              .info
              .imageMap[item]!
              .add(newImage); // todo
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
