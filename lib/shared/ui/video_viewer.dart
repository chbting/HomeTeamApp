import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:video_player/video_player.dart';

/// The parent of this widget needs to handle the [VideoViewerOption] being
/// popped.
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
          required File video,
          required String heroTag,
          required double aspectRatio,
          required Widget? preview}) =>
      _HeroVideoViewer(
          key: key,
          video: video,
          heroTag: heroTag,
          aspectRatio: aspectRatio,
          preview: preview);

  final File video;
  final String heroTag;
  final double aspectRatio;
  final Widget? preview;

  @override
  State<StatefulWidget> createState() => VideoViewerState();
}

class VideoViewerState extends State<VideoViewer> {
  late Future<void> _initializeFuture;
  late VideoPlayerController _baseController;
  late ChewieController _controller;

  @override
  void initState() {
    _baseController = VideoPlayerController.file(widget.video);
    _initializeFuture = VideoPlayerController.file(widget.video).initialize();
    super.initState();
  }

  @override
  void dispose() {
    _baseController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .pop<VideoViewerOption>(VideoViewerOption.change),
              icon: const Icon(Icons.change_circle)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
          IconButton(
              onPressed: () => Navigator.of(context)
                  .pop<VideoViewerOption>(VideoViewerOption.delete),
              icon: const Icon(Icons.delete))
        ],
      )),
      body: Center(child: _getVideoPlayerBuilder()),
    );
  }

  Widget _getVideoPlayerBuilder() {
    return FutureBuilder(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _getVideoPlayer(context);
        } else {
          return const SizedBox(
              width: 48.0, height: 48.0, child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _getVideoPlayer(BuildContext context) {
    _controller = ChewieController(
      videoPlayerController: _baseController,
      aspectRatio: _baseController.value.size.width /
          _baseController.value.size.height, //todo check
      autoPlay: true,
      looping: false,
      optionsTranslation: _getOptionsTranslation(context)
    );
    return Chewie(controller: _controller);
  }

  OptionsTranslation _getOptionsTranslation(BuildContext context) =>
      OptionsTranslation(
          playbackSpeedButtonText: S.of(context).playback_speed,
          subtitlesButtonText: S.of(context).subtitles,
          cancelButtonText: S.of(context).cancel);
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
  Widget _getVideoPlayerBuilder() {
    return Hero(
      tag: widget.heroTag,
      child: FutureBuilder(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _controller = ChewieController(
              aspectRatio: widget.aspectRatio,
              videoPlayerController: _baseController,
              autoPlay: true,
              looping: false,
              optionsTranslation: _getOptionsTranslation(context)//todo text color in light theme
            );
            return Chewie(controller: _controller);
          } else {
            return AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: Stack(
                children: [
                  Center(child: widget.preview),
                  const Center(
                    child: SizedBox(
                        width: 48.0,
                        height: 48.0,
                        child: CircularProgressIndicator()),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

enum VideoViewerOption { delete, change }
