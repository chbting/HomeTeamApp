import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';

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
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // return a non-null value triggers an action
              Navigator.of(context).pop(true);
            },
            label: Text(S.of(context).change_photo),
            icon: const Icon(Icons.edit)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Center(
            child: Hero(
                tag: heroTag, child: Image.file(image, fit: BoxFit.contain))));
  }
}
