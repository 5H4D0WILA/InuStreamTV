import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

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

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<dynamic>(
          future: streamingData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data['sources'][0]['url']);
              videoPlayerController.dispose();
              videoPlayerController = VideoPlayerController.network(
                  snapshot.data['sources'][0]['url'],
                  formatHint: VideoFormat.hls,
                  httpHeaders: {
                    'user-agent':
                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0',
                  });
              videoPlayerController.initialize();
              chewieController = ChewieController(
                videoPlayerController: videoPlayerController,
                autoPlay: true,
                fullScreenByDefault: true,
                aspectRatio: 16 / 9,
              );
              loadedOnce = true;

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
        ),
      ),
    );
  }
}
