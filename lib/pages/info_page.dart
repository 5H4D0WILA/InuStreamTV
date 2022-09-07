import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inustream_android_tv/pages/watch_page.dart';

class InfoPage extends StatefulWidget {
  final String anilistId;
  const InfoPage({Key? key, required this.anilistId}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Future<dynamic> getAnimeInfo() async {
    var response = await http.get(Uri.parse(
        'https://consumet-api.herokuapp.com/meta/anilist/data/${widget.anilistId}'));
    return jsonDecode(response.body);
  }

  Future<dynamic> getEpisodes() async {
    var response = await http.get(Uri.parse(
        'https://consumet-api.herokuapp.com/meta/anilist/episodes/${widget.anilistId}?provider=zoro'));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff16151A),
      body: Container(
        child: Column(
          children: [
            FutureBuilder<dynamic>(
              future: getAnimeInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Blur(
                          blurColor: Color(0xff16151A),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Image(
                              image: NetworkImage(
                                snapshot.data['cover'],
                              ),
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xff16151A),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150.0,
                                      height: 220.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            blurRadius: 12.0,
                                            spreadRadius: 6.0,
                                          )
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image(
                                        image: NetworkImage(
                                          snapshot.data['image'],
                                        ),
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24.0,
                                    ),
                                    Container(
                                      height: 220.0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data['title']['english'],
                                            style: TextStyle(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            snapshot.data['title']['romaji'],
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                                    .withOpacity(0.7)),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Episodes: ' +
                                                    snapshot
                                                        .data['totalEpisodes']
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 188, 188, 188),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              Text(
                                                ' • ',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 188, 188, 188),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              Text(
                                                'Duration: ' +
                                                    snapshot.data['duration']
                                                        .toString() +
                                                    ' min / Episode',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 188, 188, 188),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              Text(
                                                ' • ',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 188, 188, 188),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              Text(
                                                'Rating: ' +
                                                    (snapshot.data['rating'] !=
                                                                null
                                                            ? (snapshot.data[
                                                                    'rating'] /
                                                                10)
                                                            : 0)
                                                        .toString() +
                                                    ' / 10',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 188, 188, 188),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: ListView.builder(
                                              itemCount: snapshot
                                                  .data['genres'].length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: ((context, index) {
                                                return Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 14.0,
                                                              vertical: 4.0),
                                                      child: Center(
                                                        child: Text(
                                                          snapshot.data[
                                                              'genres'][index],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 14.0),
                                child: Text(
                                  'Episodes',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              FutureBuilder<dynamic>(
                                  future: getEpisodes(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        height: 150.0,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: ((context, index) {
                                            return Row(
                                              children: [
                                                EpisodeCard(
                                                  episodeData:
                                                      snapshot.data[index],
                                                ),
                                                SizedBox(
                                                  width: 12.0,
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 150.0,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }
                                  }))
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class EpisodeCard extends StatefulWidget {
  final dynamic episodeData;
  const EpisodeCard({
    Key? key,
    required this.episodeData,
  }) : super(key: key);

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return DpadContainer(
      onFocus: (isFocused) {
        setState(() {
          isSelected = isFocused;
        });
      },
      onClick: () {
        Get.to(WatchPage(episodeId: widget.episodeData['id']));
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: isSelected ? 160.0 : 124.0,
            height: isSelected ? 90.0 : 70.0,
            decoration: BoxDecoration(
              borderRadius: isSelected
                  ? BorderRadius.circular(12.0)
                  : BorderRadius.circular(8.0),
              color: Colors.blueGrey,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Image(
                  image: NetworkImage(
                    widget.episodeData['image'],
                  ),
                  fit: BoxFit.cover,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: isSelected ? 160.0 : 124.0,
                  height: isSelected ? 90.0 : 70.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  alignment: Alignment.topRight,
                  child: Text(
                    (widget.episodeData['number']).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: isSelected ? 146.0 : 118.0,
            child: Text(
              widget.episodeData['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
