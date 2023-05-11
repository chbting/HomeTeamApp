import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// If the FloatingActionButton is press, this widget will pop [true], the
/// parent of this widget needs to handle that.
class VideoViewer extends StatefulWidget {
  const VideoViewer({Key? key, required this.video})
      : heroTag = '',
        aspectRatio = 1.0,
        preview = null,
        super(key: key);

  const VideoViewer._hero(
      {super.key,
      required this.video,
      required this.heroTag,
      required this.aspectRatio,
      required this.preview});

  factory VideoViewer.hero(
          {Key? key,
          required video,
          required heroTag,
          required aspectRatio,
          required preview}) =>
      _HeroVideoViewer(
          key: key,
          video: video,
          heroTag: heroTag,
          aspectRatio: aspectRatio,
          preview: preview);

  final File video;
  final String heroTag;
  final double aspectRatio;
  final Image? preview;

  @override
  State<StatefulWidget> createState() => VideoViewerState();
}

class VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.video);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0.0), // todo color
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent, //todo not transparent
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //TextButton.icon(onPressed: (){}, icon: Icon(Icons.change_circle), label: Text(S.of(context).change_photo)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.change_circle)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop<VideoViewerOption>(VideoViewerOption.delete);
                  },
                  icon: const Icon(Icons.delete))
            ],
          )),
      body: Center(child: _getVideoPlayer()),
    );
  }

  Widget _getVideoPlayer() {
    return FutureBuilder(
      future: _controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
              aspectRatio:
                  _controller.value.size.width / _controller.value.size.height,
              child: VideoPlayer(_controller)); //todo autoplay
        } else {
          return const SizedBox(
              width: 48.0, height: 48.0, child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _HeroVideoViewer extends VideoViewer {
  const _HeroVideoViewer(
      {key,
      required video,
      required heroTag,
      required aspectRatio,
      required preview})
      : super._hero(
            key: key,
            video: video,
            heroTag: heroTag,
            aspectRatio: aspectRatio,
            preview: preview);

  @override
  State<StatefulWidget> createState() => _HeroVideoViewerState();
}

class _HeroVideoViewerState extends VideoViewerState {
  @override
  Widget _getVideoPlayer() {
    return Hero(
      tag: widget.heroTag,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: FutureBuilder(
          future: _controller.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return VideoPlayer(_controller); //todo autoplay
            } else {
              return Stack(
                children: [
                  Center(child: widget.preview),
                  const Center(
                    child: SizedBox(
                        width: 48.0,
                        height: 48.0,
                        child: CircularProgressIndicator()),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

enum VideoViewerOption { delete, change }
