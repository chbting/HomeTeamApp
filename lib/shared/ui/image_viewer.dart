import 'dart:io';

import 'package:flutter/material.dart';
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
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
        bottomNavigationBar: BottomAppBar(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
        //       icon: const Icon(Icons.delete), label: S.of(context).delete),
        //   NavigationDestination(
        //       icon: const Icon(Icons.edit), label: S.of(context).change_photo),
        // ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Center(
          child: Hero(
              tag: heroTag,
              child: PhotoView(
                imageProvider: FileImage(image),
                minScale: PhotoViewComputedScale.contained * 0.9,
                maxScale: PhotoViewComputedScale.covered * 2.8,
              )),
        ));
  }
}

enum ImageViewerOption { delete, change }
