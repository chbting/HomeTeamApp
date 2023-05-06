import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:photo_view/photo_view.dart';

/// If the FloatingActionButton is press, this widget will pop [true], the
/// parent of this widget needs to handle that.
class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key, required this.image, required this.heroTag})
      : super(key: key);

  final File image;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, elevation: 0.0), // todo color
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent, //todo not transparent
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //TextButton.icon(onPressed: (){}, icon: Icon(Icons.change_circle), label: Text(S.of(context).change_photo)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.change_circle)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop<ImageViewerOption>(ImageViewerOption.delete);
                },
                icon: const Icon(Icons.delete))
          ],
        )),
        // bottomNavigationBar: NavigationBar(destinations: [
        //   NavigationDestination(
        //       icon: const Icon(Icons.change_circle), label: S.of(context).change_photo),
        //   NavigationDestination(
        //       icon: const Icon(Icons.tune), label: 'adjust'),
        //   NavigationDestination(
        //       icon: const Icon(Icons.delete), label: S.of(context).delete),
        // ]),
        body: Center(
          child: Hero(
              tag: heroTag,
              child: PhotoView(//todo do list
                imageProvider: FileImage(image),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
              )),
        ));
  }
}

enum ImageViewerOption { delete, change }
