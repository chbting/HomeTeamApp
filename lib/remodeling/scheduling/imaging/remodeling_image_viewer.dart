import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';

class RemodelingImageViewer extends StatelessWidget {
  const RemodelingImageViewer({Key? key, required this.image, required this.heroTag})
      : super(key: key);

  final File image;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    // todo image can overflow
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // return true to trigger retaking
              Navigator.of(context).pop(true); //todo consolidate logic
            },
            label: Text(S.of(context).change_photo),
            icon: const Icon(Icons.edit)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Center(child: Hero(tag: heroTag, child: Image.file(image))));
  }
}
