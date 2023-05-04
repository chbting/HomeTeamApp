import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hometeam_client/data/room_type.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/json_model/room.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_image_wizard.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/theme/theme.dart';
import 'package:hometeam_client/shared/ui/image_viewer.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:path/path.dart';

class PropertyImagesWidget extends StatefulWidget {
  const PropertyImagesWidget({Key? key}) : super(key: key);

  @override
  State<PropertyImagesWidget> createState() => PropertyImagesWidgetState();
}

class PropertyImagesWidgetState extends State<PropertyImagesWidget> {
  final _gridviewSpacing = 8.0;
  late Property _property;

  @override
  Widget build(BuildContext context) {
    _property = ListingInheritedData.of(context)!.property;

    // Initialize the room image map
    if (_property.rooms.isEmpty) {
      _property.rooms[RoomType.livingDiningRoom] = [Room()];
      _property.rooms[RoomType.others] = [Room()];
      _property.rooms[RoomType.bedroom] =
          List.generate(_property.bedroom, (index) => Room());
      _property.rooms[RoomType.bathroom] =
          List.generate(_property.bathroom, (index) => Room());
    } else {
      _updateRoomCountIfNeeded(RoomType.bedroom, _property.bedroom);
      _updateRoomCountIfNeeded(RoomType.bathroom, _property.bathroom);
    }

    int itemCount = 2; // livingDiningRoom and others
    _property.bedroom > 0 ? itemCount++ : null;
    _property.bathroom > 0 ? itemCount++ : null;

    return ListView(
        padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 8.0,
            bottom: StandardStepper.buttonBarHeight),
        primary: false,
        children: [
          _getRoomSection(context, RoomType.livingDiningRoom),
          _property.bedroom > 0
              ? _getRoomSection(context, RoomType.bedroom)
              : const SizedBox(),
          _property.bathroom > 0
              ? _getRoomSection(context, RoomType.bathroom)
              : const SizedBox(),
          _getRoomSection(context, RoomType.others)
        ]);
  }

  /// Generate a new room list for the specified room type if the count changed.
  /// Preserving previously taken images and removing unnecessary cache images.
  void _updateRoomCountIfNeeded(RoomType type, int newCount) {
    List<Room> roomList = _property.rooms[type]!;
    if (newCount != roomList.length) {
      if (newCount < roomList.length) {
        for (var room in roomList) {
          for (var image in room.images) {
            image.delete().ignore();
          }
        }
      }
      _property.rooms[type] = List.generate(newCount,
          (index) => index < roomList.length ? roomList[index] : Room());
    }
  }

  Widget _getRoomSection(BuildContext context, RoomType type) {
    int itemCount = _property.rooms[type]!.length;
    return Card(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        itemCount: _property.rooms[type]!.length,
        itemBuilder: (context, index) {
          List<File> images = _property.rooms[type]![index].images;
          String title = RoomTypeHelper.getName(context, type);
          if (type == RoomType.bedroom && _property.bedroom > 1 ||
              type == RoomType.bathroom && _property.bathroom > 1) {
            title += ' ${index + 1}';
          }
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                leading: SizedBox(
                    // Explicitly center the icon only when there are images
                    height: images.isEmpty ? double.infinity : 0.0,
                    child: index == 0
                        ? Icon(RoomTypeHelper.getIconData(type))
                        : null),
                title: Text(title),
                subtitle: images.isEmpty
                    ? Text(
                        type == RoomType.others
                            ? S.of(context).photo_optional
                            : S.of(context).photo_required,
                        style: AppTheme.getListTileBodyTextStyle(context))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(S.of(context).photo_added,
                                  style: AppTheme.getListTileBodyTextStyle(
                                      context))),
                          GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: _gridviewSpacing,
                                      crossAxisSpacing: _gridviewSpacing),
                              itemCount: images.length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, imageIndex) {
                                return _getEnlargeableThumbnail(
                                    context, type, index, imageIndex);
                              }),
                        ],
                      ),
                trailing: images.isEmpty
                    ? IconButton(
                        icon: Icon(Icons.add_circle,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: () => _openImageWizard(context, type, index))
                    : IconButton(
                        icon: Icon(Icons.check_circle,
                            color: Theme.of(context).colorScheme.secondary),
                        onPressed: null),
              ),
              itemCount > 1 && index < itemCount - 1
                  ? const Divider(indent: AppTheme.listTileLeadingIndent, endIndent: 8.0)
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }

  Widget _getEnlargeableThumbnail(
      BuildContext context, RoomType type, int roomIndex, int imageIndex) {
    File image = _property.rooms[type]![roomIndex].images[imageIndex];
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
                  })).then((retake) {
                    if (retake != null) {
                      _openImageWizardForRetake(
                          context, type, roomIndex, imageIndex);
                    }
                  });
                }))));
  }

  void _openImageWizard(BuildContext context, RoomType type, int roomIndex) {
    Navigator.of(context)
        .push(MaterialPageRoute<List<File>>(
            builder: (context) => PropertyImagesWizard(
                  type: type,
                  roomIndex: roomIndex,
                )))
        .then((images) {
      if (images != null) {
        setState(() {
          _property.rooms[type]![roomIndex].images = images;
          //todo update button state
        });
      }
    });
  }

  void _openImageWizardForRetake(
      BuildContext context, RoomType type, int roomIndex, int imageIndex) {
    Navigator.of(context)
        .push(MaterialPageRoute<List<File>>(
            builder: (context) => PropertyImagesWizard(
                type: type,
                roomIndex: roomIndex,
                imageIndex: imageIndex,
                retake: true)))
        .then((images) {
      if (images != null) {
        setState(() {
          _property.rooms[type]![roomIndex].images = images;
          //todo update button state
        });
      }
    });
  }
}
