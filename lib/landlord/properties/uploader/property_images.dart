import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/data/room.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_image_wizard.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_uploader_inherited_data.dart';
import 'package:hometeam_client/ui/shared/image_viewer.dart';
import 'package:hometeam_client/ui/shared/standard_stepper.dart';
import 'package:hometeam_client/ui/theme.dart';
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
    _property = PropertyUploaderInheritedData.of(context)!.property;

    // Initialize image lists, if empty or
    // todo persistence unless room number changes, remove unnecessary images
    if (_property.rooms.isEmpty || _check()) {
      _property.rooms[0] = Room(RoomType.livingDiningRoom);
      for (int i = 1; i <= _property.bedroom; i++) {
        _property.rooms[i] = Room(RoomType.bedroom);
      }
      for (int j = _property.bedroom + 1;
          j <= _property.bedroom + _property.bathroom;
          j++) {
        _property.rooms[j] = Room(RoomType.bathroom);
      }
      _property.rooms[_property.bedroom + _property.bathroom + 1] =
          Room(RoomType.others);
    }

    return ListView.builder(
        padding: const EdgeInsets.only(
            left: 8.0, right: 8.0, bottom: StandardStepper.bottomMargin),
        primary: false,
        itemCount: _property.rooms.length,
        itemBuilder: (context, index) {
          Room room = _property.rooms[index]!;

          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              leading: SizedBox(
                  // Explicitly center the icon only when there are images
                  height: room.images.isEmpty ? double.infinity : 0.0,
                  child: Icon(RoomHelper.getIconData(room.type))),
              title: Text(RoomHelper.getName(context, room.type)),
              subtitle: room.images.isEmpty
                  ? Text(S.of(context).photo_required,
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
                            itemCount: room.images.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, imageIndex) {
                              return _getEnlargeableThumbnail(
                                  context, index, imageIndex);
                            })
                      ],
                    ),
              trailing: room.images.isEmpty
                  ? const Icon(Icons.add_circle)
                  : Icon(Icons.check_circle,
                      color: Theme.of(context).colorScheme.secondary),
              onTap: room.images.isEmpty
                  ? () => _openImageWizard(context, index)
                  : null,
            ),
          );
        });
  }

  bool _check() {
    return false;
  }

  void _openImageWizard(BuildContext context, int roomKey) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => PropertyImagesWizard(roomKey: roomKey)))
        .then((images) {
      if (images != null) {
        setState(() {
          _property.rooms[roomKey]!.images = images;
          //todo RemodelingInheritedData.of(context)!.updateRightButtonState();
        });
      }
    });
  }

  void _openImageWizardForRetake(
      BuildContext context, int roomKey, int imageIndex) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => PropertyImagesWizard(
                roomKey: roomKey, imageIndex: imageIndex, retake: true)))
        .then((images) {
      if (images != null) {
        setState(() {
          //todo image not updating
          _property.rooms[roomKey]!.images = images;
          //todo RemodelingInheritedData.of(context)!.updateRightButtonState();
        });
      }
    });
  }

  Widget _getEnlargeableThumbnail(
      BuildContext context, int roomKey, int imageIndex) {
    var image = _property.rooms[roomKey]!.images[imageIndex];
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
                      _openImageWizardForRetake(context, roomKey, imageIndex);
                    }
                  });
                }))));
  }
}
