import 'dart:convert';

import 'package:bordered_text/bordered_text.dart';
import 'package:chewie/chewie.dart';
import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:subtitle/subtitle.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart' as chewie;
import 'package:inustream_android_tv/widgets/custom_controls.dart';

class WatchPage extends StatefulWidget {
  final dynamic episodeId;
  const WatchPage({
    Key? key,
    required this.episodeId,
  }) : super(key: key);

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  Future<dynamic> getEpisodes() async {
    var response = await http.get(Uri.parse(
        'https://consumet-api.herokuapp.com/meta/anilist/watch/${widget.episodeId}?provider=zoro'));
    return jsonDecode(response.body);
  }

  var streamingData;

  bool loadedOnce = false;
  late FocusNode fn;
  bool isPlaying = false;
  String keyLabel = '';

  int durationSeconds = 1;
  int currentSeconds = 1;

  Subtitles subtitleList = Subtitles([]);

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late SubtitleController subtitleController;

  @override
  void initState() {
    fn = FocusNode();
    videoPlayerController = VideoPlayerController.network('',
        formatHint: VideoFormat.hls,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0',
        });

    streamingData = getEpisodes();
    videoPlayerController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: fn,
      onKey: (value) {
        print(value);
        setState(() {
          keyLabel = value.logicalKey.keyLabel;
        });
        // Arrow Up/Down/Left/Right
        // Media Play Pause
        // Context Menu
        // Media Fast Forward
        // Media Rewind

        if ((value.logicalKey.keyLabel == 'Media Play Pause') &&
            value.runtimeType.toString() == 'RawKeyUpEvent') {
          if (chewieController.isPlaying) {
            print('PAUSE!!');
            chewieController.pause();
          } else {
            print('PLAY!!');
            chewieController.play();
          }
        } else if ((value.logicalKey.keyLabel == 'Media Fast Forward') &&
            value.runtimeType.toString() == 'RawKeyUpEvent') {
          chewieController.seekTo(
              chewieController.videoPlayerController.value.position +
                  Duration(seconds: 10));
        } else if ((value.logicalKey.keyLabel == 'Media Rewind') &&
            value.runtimeType.toString() == 'RawKeyUpEvent') {
          chewieController.seekTo(
              chewieController.videoPlayerController.value.position -
                  Duration(seconds: 10));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: !loadedOnce
              ? FutureBuilder<dynamic>(
                  future: streamingData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data['sources'][0]['url']);

                      var subs = snapshot.data['subtitles'];
                      var selectedSubtitle;

                      var i = 0;
                      for (var subtitle in subs) {
                        if (subtitle['lang'] == 'English') {
                          selectedSubtitle = i;
                          break;
                        }
                        i++;
                      }

                      subtitleController = SubtitleController(
                        provider: SubtitleProvider.fromNetwork(
                          Uri.parse(
                            subs[selectedSubtitle]['url'],
                          ),
                        ),
                      );

                      subtitleController.initial().whenComplete(() => {
                            setState(() async {
                              videoPlayerController =
                                  VideoPlayerController.network(
                                      snapshot.data['sources'][0]['url'],
                                      formatHint: VideoFormat.hls,
                                      httpHeaders: {
                                    'user-agent':
                                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0',
                                  });

                              subtitleList = Subtitles(subtitleController
                                  .subtitles
                                  .map((e) => chewie.Subtitle(
                                      index: e.index,
                                      start: e.start,
                                      end: e.end,
                                      text: e.data))
                                  .toList());

                              await videoPlayerController.initialize();
                              chewieController = ChewieController(
                                videoPlayerController: videoPlayerController,
                                autoPlay: true,
                                fullScreenByDefault: true,
                                aspectRatio: 16 / 9,
                                autoInitialize: true,
                                customControls: CustomControls(),
                                subtitle: subtitleList,
                                subtitleBuilder: (context, subtitle) =>
                                    Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2.0,
                                          left: 2.0,
                                        ),
                                        child: BorderedText(
                                          strokeColor: Colors.black,
                                          child: Text(
                                            subtitle,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      BorderedText(
                                        strokeColor: Colors.black,
                                        child: Text(
                                          subtitle,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              loadedOnce = true;

                              currentSeconds = 100;
                            })
                          });

                      //videoPlayerController.initialize();
                      return Chewie(
                        controller: chewieController,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                )
              : Chewie(
                  controller: chewieController,
                ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return DpadContainer(
      onClick: () {},
      onFocus: (isFocused) {
        setState(() {
          isSelected = isFocused;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.grey.withOpacity(0.7) : Colors.transparent,
        ),
        child: Icon(
          FontAwesomeIcons.play,
          color: Colors.white,
        ),
      ),
    );
  }
}
