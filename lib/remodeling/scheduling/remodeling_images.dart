import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/imaging/image_viewer.dart';
import 'package:tner_client/remodeling/scheduling/imaging/remodeling_image_wizard.dart';
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
          var imageList = info.imageMap[item];
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              leading: SizedBox(
                  // Explicitly center the icon only when there are images
                  height: imageList == null ? double.infinity : 0.0,
                  child: Icon(RemodelingItemHelper.getIconData(item))),
              title: Text(RemodelingItemHelper.getItemName(item, context)),
              subtitle: pictureRequired
                  ? imageList == null
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
                                  return _getEnlargeableThumbnail(
                                      imageList[index], context);
                                })
                          ],
                        )
                  : Text(S.of(context).picture_not_required,
                      style: AppTheme.getListTileBodyTextStyle(context)),
              trailing: pictureRequired && imageList == null
                  ? const Icon(Icons.add_circle)
                  : Icon(Icons.check_circle,
                      color: Theme.of(context).toggleableActiveColor),
              onTap: pictureRequired && imageList == null
                  ? () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  RemodelingImageWizard(item: item)))
                          .then((imageList) {
                        if (imageList != null) {
                          setState(() {
                            RemodelingInheritedData.of(context)!
                                .info
                                .imageMap[item] = imageList;
                            RemodelingInheritedData.of(context)!
                                .updateRightButtonState();
                          });
                        }
                      });
                    }
                  : null,
            ),
          );
        });
  }

  Widget _getEnlargeableThumbnail(File image, BuildContext context) {
    var heroTag = basename(image.path);
    return Hero(
        tag: heroTag,
        child: Material(
            type: MaterialType.transparency,
            child: Ink.image(
                image: FileImage(image),
                fit: BoxFit.cover,
                child: InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImageViewer(heroTag: heroTag, image: image);
                  }));
                  // todo option to retake this and retake all images
                }))));
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
                },
                child: Text(S.of(context).retake),
              )
            ],
          );
        });
  }
}
