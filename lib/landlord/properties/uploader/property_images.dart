import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hometeam_client/data/room_type.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/json_model/room.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/image_viewer.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/shared/ui/video_viewer.dart';
import 'package:hometeam_client/theme/theme.dart';
import 'package:hometeam_client/utils/file_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
          _getVideoSection(context),
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

  Widget _getVideoSection(BuildContext context) {
    return Card(
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          leading: SizedBox(
              // Explicitly center the icon only when there are images
              height: _property.video == null ? double.infinity : 0.0,
              child: const Icon(Icons.movie_outlined)),
          title: Text(S.of(context).video),
          subtitle: _property.video == null
              ? Text(S.of(context).video_required,
                  style: AppTheme.getListTileBodyTextStyle(context))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).video_added,
                            style: AppTheme.getListTileBodyTextStyle(context))),
                    GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: _gridviewSpacing,
                            crossAxisSpacing: _gridviewSpacing),
                        itemCount: _property.video == null ? 0 : 1,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, imageIndex) =>
                            _getVideoThumbnail(context, _property.video!))
                  ],
                ),
          trailing: _property.video == null
              ? IconButton(
                  icon: Icon(Icons.add_circle,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () =>
                      _pickVideo(context)) //todo remove the original
              : const IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: null)),
    );
  }

  void _pickVideo(BuildContext context) {
    _openVideoPickerDialog(context).then((cachedVideo) {
      if (cachedVideo != null) {
        setState(() => _property.video = cachedVideo);
      }
    });
  }

  Widget _getVideoThumbnail(BuildContext context, File video) {
    Completer completer = Completer();
    Widget? thumbnail;
    double aspectRatio = 1.0;
    VideoThumbnail.thumbnailData(
            video: video.path, imageFormat: ImageFormat.PNG)
        .then((memoryImage) async {
      if (memoryImage == null) {
        thumbnail = Container(
            color: Colors.black, child: const Center(child: Icon(Icons.close)));
      } else {
        thumbnail = Image.memory(fit: BoxFit.cover, memoryImage);
        var image = await decodeImageFromList(memoryImage);
        aspectRatio = image.width / image.height;
      }
      completer.complete();
    });

    return FutureBuilder(
      future: completer.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var heroTag = basename(video.path);
          return Hero(
              tag: heroTag,
              child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                      onTap: () => Navigator.push(context,
                              MaterialPageRoute<VideoViewerOption>(
                                  builder: (context) {
                            return VideoViewer.hero(
                                heroTag: heroTag,
                                aspectRatio: aspectRatio,
                                preview: thumbnail,
                                video: video);
                          })).then((videoViewerOption) {
                            if (videoViewerOption != null) {
                              switch (videoViewerOption) {
                                case VideoViewerOption.delete:
                                  var videoToBeDeleted = _property.video;
                                  setState(() => _property.video = null);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(
                                            bottom: StandardStepper
                                                .buttonBarHeight),
                                        content:
                                            Text(S.of(context).video_removed),
                                        action: SnackBarAction(
                                            label: S.of(context).undo,
                                            onPressed: () => setState(() =>
                                                _property.video =
                                                    videoToBeDeleted)),
                                      ))
                                      .closed
                                      .then((snackBarClosedReason) =>
                                          snackBarClosedReason ==
                                                  SnackBarClosedReason.action
                                              ? null
                                              : videoToBeDeleted
                                                  ?.delete()
                                                  .ignore());
                                  break;
                                case VideoViewerOption.change:
                                  _pickVideo(context);
                                  break;
                              }
                            }
                          }),
                      child: thumbnail)));
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
            ),
          );
        }
      },
    );
  }

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
                          List<File> cachedImages =
                              await _openImagePickerDialog(context);
                          setState(() => _property
                              .rooms[type]![roomIndex].images = cachedImages);
                        })
                    : const IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.green),
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

  Widget _getImageGridView(List<File> images, RoomType type, int roomIndex) {
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
              ? _getEnlargeableThumbnail(context, images[imageIndex])
              : Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2.0,
                          color: Theme.of(context).colorScheme.secondary)),
                  child: InkWell(
                    onTap: () async {
                      List<File> cachedImages =
                          await _openImagePickerDialog(context);
                      setState(() => images.addAll(cachedImages));
                    },
                    child: Icon(Icons.add,
                        size: 32.0,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                );
        });
  }

  Widget _getEnlargeableThumbnail(BuildContext context, File image) {
    var heroTag = basename(image.path);
    return Hero(
        tag: heroTag,
        child: Material(
            type: MaterialType.transparency,
            child: Ink.image(
                image: FileImage(image),
                fit: BoxFit.cover,
                child: InkWell(onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<ImageViewerOption>(builder: (context) {
                    return ImageViewer(heroTag: heroTag, image: image);
                  })).then((imageViewerOption) {
                    if (imageViewerOption != null) {
                      switch (imageViewerOption) {
                        case ImageViewerOption.delete:
                          //todo delete with snackbar undo
                          break;
                        case ImageViewerOption.change:
                          _openImagePickerDialog(context); //todo
                          break;
                      }
                    }
                  });
                }))));
  }

  Future<File?> _openVideoPickerDialog(BuildContext context) async {
    File? video;
    switch (await showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(S.of(context).add_video),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                child: ListTile(
                    leading: const Icon(Icons.videocam),
                    title: Text(S.of(context).record)),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                child: ListTile(
                    leading: const Icon(Icons.video_library),
                    title: Text(S.of(context).select_from_gallery)),
              ),
            ],
          );
        })) {
      // todo when user backpressed in a camera section without taking a picture, a placeholder image file is created but show as null for the return value
      case ImageSource.camera:
        XFile? savedVideo = await _picker.pickVideo(source: ImageSource.camera);
        if (savedVideo != null) {
          video = await FileHelper.moveToCache(
              file: File(savedVideo.path),
              subDirectory: FileHelper.propertyUploaderCache,
              newFileName: FileHelper.getUuidFilename(savedVideo.path));
        }
        break;
      case ImageSource.gallery:
        XFile? videoPicked =
            await _picker.pickVideo(source: ImageSource.gallery);
        if (videoPicked != null) {
          video = await FileHelper.moveToCache(
              file: File(videoPicked.path),
              subDirectory: FileHelper.propertyUploaderCache,
              newFileName: FileHelper.getUuidFilename(videoPicked.path));
          // Remove the wrapper directory created by the image picker
          File(videoPicked.path).parent.delete(recursive: false).ignore();
        }
        break;
      default:
        break;
    }
    return video;
  }

  Future<List<File>> _openImagePickerDialog(BuildContext context) async {
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
      // todo when user backpressed in a camera section without taking a picture, a placeholder image file is created but show as null for the return value
      case ImageSource.camera:
        XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image == null) {
          return [];
        } else {
          File imageFile = await FileHelper.moveToCache(
              file: File(image.path),
              subDirectory: FileHelper.propertyUploaderCache,
              newFileName: FileHelper.getUuidFilename(image.path));
          return [imageFile];
        }
      case ImageSource.gallery:
        List<XFile> images = await _picker.pickMultiImage();
        List<File> cachedImages = [];
        for (var image in images) {
          File cachedImage = await FileHelper.moveToCache(
              file: File(image.path),
              subDirectory: FileHelper.propertyUploaderCache,
              newFileName: FileHelper.getUuidFilename(image.path));
          // Remove the wrapper directory created by the image picker
          File(image.path).parent.delete(recursive: false).ignore();
          cachedImages.add(cachedImage);
        }
        return cachedImages;
      default:
        return [];
    }
  }
}
