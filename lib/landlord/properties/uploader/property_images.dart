import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hometeam_client/data/room_type.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/json_model/room.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_image_wizard.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/image_viewer.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/theme/theme.dart';
import 'package:hometeam_client/utils/file_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PropertyImagesWidget extends StatefulWidget {
  const PropertyImagesWidget({Key? key}) : super(key: key);

  @override
  State<PropertyImagesWidget> createState() => PropertyImagesWidgetState();
}

class PropertyImagesWidgetState extends State<PropertyImagesWidget> {
  final ImagePicker _picker = ImagePicker();
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
          //todo video section
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

  // @override
  // void initState() {
  //   debugPrint('init');
  //   _printFiles().then((value) => debugPrint(value));
  //   super.initState();
  // }

  Widget _getRoomSection(BuildContext context, RoomType type) {
    int roomCount = _property.rooms[type]!.length;
    return Card(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        itemCount: _property.rooms[type]!.length,
        itemBuilder: (context, roomIndex) {
          List<File> images = _property.rooms[type]![roomIndex].images;
          String title = RoomTypeHelper.getName(context, type);
          if (type == RoomType.bedroom && _property.bedroom > 1 ||
              type == RoomType.bathroom && _property.bathroom > 1) {
            title += ' ${roomIndex + 1}';
          }
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                leading: SizedBox(
                    // Explicitly center the icon only when there are images
                    height: images.isEmpty ? double.infinity : 0.0,
                    child: roomIndex == 0
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
                          _getImageGridView(images, type, roomIndex),
                        ],
                      ),
                trailing: images.isEmpty
                    ? IconButton(
                        icon: Icon(Icons.add_circle,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: () async {
                          List<XFile> pickedImages =
                              await _openImagePickerDialog(context);
                          List<File> cachedImages = await _cacheImages(
                              pickedImages, type, roomCount, roomIndex); // todo maybe it's not a good idea to rename them because the user can rearrange/delete images
                          setState(() {
                            _property.rooms[type]![roomIndex].images =
                                cachedImages;
                          });

                          // debugPrint('cached');
                          // String s = await _printFiles();
                          // debugPrint(s);
                        })
                    : IconButton(
                        icon: Icon(Icons.check_circle,
                            color: Theme.of(context).colorScheme.secondary),
                        onPressed: null),
              ),
              roomCount > 1 && roomIndex < roomCount - 1
                  ? const Divider(
                      indent: AppTheme.listTileLeadingIndent, endIndent: 8.0)
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }

  // // todo debug section
  // Future<String> _printFiles() {
  //   Completer<String> c = Completer<String>();
  //   FileHelper.getCacheDirectory().then((dir) {
  //     FileHelper.dirContents(dir).then((l) {
  //       String s = '';
  //       s += 'size: ${l.length}';
  //       for (var element in l) {
  //         s += '\n$element';
  //       }
  //       c.complete(s);
  //     });
  //   });
  //   return c.future;
  // }

  //todo don't use globals here?
  Widget _getImageGridView(List<File> images, RoomType type, int roomIndex) {
    debugPrint('$images');
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: _gridviewSpacing,
            crossAxisSpacing: _gridviewSpacing),
        itemCount: images.length + 1,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, imageIndex) {
          return imageIndex < images.length
              ? _getEnlargeableThumbnail(
                  context,
                  type,
                  _property.rooms[type]![roomIndex].images[imageIndex],
                  roomIndex,
                  imageIndex)
              : Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2.0,
                          color: Theme.of(context).colorScheme.secondary)),
                  child: InkWell(
                    onTap: () async {
                      List<XFile> pickedImages =
                          await _openImagePickerDialog(context);
                      List<File> cachedImages = await _cacheImages(pickedImages,
                          type, _property.rooms[type]!.length, roomIndex,
                          startIndex: _property.rooms[type]!.length);
                      setState(() {
                        _property.rooms[type]![roomIndex].images
                            .addAll(cachedImages);
                      });
                    },
                    child: Icon(Icons.add,
                        size: 32.0,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                );
        });
  }

  Widget _getEnlargeableThumbnail(BuildContext context, RoomType type,
      File image, int roomIndex, int imageIndex) {
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
                    //todo skip wizard, should be able to remove picture in the viewer
                    if (retake != null) {
                      _openImageWizardForRetake(
                          context, type, roomIndex, imageIndex);
                    }
                  });
                }))));
  }

  Future<List<XFile>> _openImagePickerDialog(BuildContext context) async {
    List<XFile> images = [];
    switch (await showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(S.of(context).add_photos),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                child: ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: Text(S.of(context).take_photo)),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                child: ListTile(
                    leading: const Icon(Icons.collections),
                    title: Text(S.of(context).select_from_gallery)),
              ),
            ],
          );
        })) {
      case ImageSource.camera:
        XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          images.add(image);
        }
        break;
      case ImageSource.gallery:
        images.addAll(await _picker.pickMultiImage());
        break;
      default:
        break;
    }
    return images;
  }

  /// Move the picked images to the property uploader cache folder and rename
  /// the files using this convention:
  /// {RoomType}_{RoomIndex (if any)}_{imageIndex}.{extension}
  /// The resulting file should by like this: livingDiningRoom_0.jpg,
  /// bedroom_1.png, bedroom_0_1.png, etc.
  /// This function also removes the original ImagePicker-cached image (not the
  /// original outside to app cache folder) and its container folder (gallery-
  /// picked images only).
  Future<List<File>> _cacheImages(
      List<XFile> pickedImages, RoomType type, int roomCount, int roomIndex,
      {int startIndex = 0}) async {
    var completer = Completer<List<File>>();
    List<File> images = [];
    for (int imageIndex = 0; imageIndex < pickedImages.length; imageIndex++) {
      String roomIdentifier = roomCount > 1 ? '_$roomIndex' : '';
      String imageIdentifier = '${imageIndex + startIndex}';
      String fileExtension = extension(pickedImages[imageIndex].path);
      var imageName =
          '${type.name}${roomIdentifier}_$imageIdentifier$fileExtension';

      File newFile = await FileHelper.moveToCache(
          file: File(pickedImages[imageIndex].path),
          subDirectory: FileHelper.propertyUploaderCache,
          newFileName: imageName);

      // Remove the container directory created by the image picker (gallery only)
      File(pickedImages[imageIndex].path)
          .parent
          .delete(recursive: false)
          .ignore();
      images.add(newFile);
    }
    completer.complete(images);
    return completer.future;
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
