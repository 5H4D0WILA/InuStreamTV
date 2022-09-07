import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inustream_android_tv/pages/info_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  int selectedPopularAnime = 0;

  Future<dynamic> getPopularAnime() async {
    var response = await http.get(
        Uri.parse('https://consumet-api.herokuapp.com/meta/anilist/popular'));
    return jsonDecode(response.body)['results'];
  }

  Future<dynamic> getRandomAnime() async {
    var response = await http.get(Uri.parse(
        'https://consumet-api.herokuapp.com/meta/anilist/random-anime'));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff16151A),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            width: 50.0,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(
                      'https://wallpaperaccess.com/full/6068211.jpg'),
                  radius: 16.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NavbarIcon(
                      icon: FontAwesomeIcons.house,
                      isCurrent: true,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    NavbarIcon(
                      icon: FontAwesomeIcons.magnifyingGlass,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    NavbarIcon(
                      icon: FontAwesomeIcons.plus,
                    ),
                  ],
                ),
                Icon(
                  FontAwesomeIcons.gear,
                  color: Colors.white,
                  size: 16.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: FutureBuilder<dynamic>(
                  future: getRandomAnime(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        width: MediaQuery.of(context).size.width - 50.0,
                        child: Stack(
                          children: [
                            Blur(
                                blurColor: Color(0xff16151A),
                                blur: 2,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  width:
                                      MediaQuery.of(context).size.width - 50.0,
                                  child: Image(
                                    image: NetworkImage(snapshot.data['cover']),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    filterQuality: FilterQuality.high,
                                  ),
                                )),
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  Color(0xff16151A),
                                  Color.fromARGB(142, 22, 21, 26)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 40.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data['title']['english'] ??
                                          snapshot.data['title']['romaji'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      snapshot.data['title']['native'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color:
                                            Color.fromARGB(255, 188, 188, 188),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Episodes: ' +
                                              snapshot.data['totalEpisodes']
                                                  .toString(),
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 188, 188, 188),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        Text(
                                          ' • ',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 188, 188, 188),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
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
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        Text(
                                          ' • ',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 188, 188, 188),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        Text(
                                          'Rating: ' +
                                              (snapshot.data['rating'] != null
                                                      ? (snapshot
                                                              .data['rating'] /
                                                          10)
                                                      : 0)
                                                  .toString() +
                                              ' / 10',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 188, 188, 188),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        snapshot.data['description']
                                            .toString()
                                            .replaceAll('<br>', '\n')
                                            .replaceAll('\n\n\n', '\n'),
                                        maxLines: 7,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print('INFO!!!');
                                          },
                                          child: InfoButton(
                                            id: snapshot.data['id'],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.plus,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 136, 136, 136),
                          highlightColor: Color.fromARGB(255, 102, 102, 102),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.55,
                          ));
                    }
                  },
                )),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 40.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Popular Anime',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Container(
                            height: 180.0,
                            child: FutureBuilder<dynamic>(
                              future: getPopularAnime(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: 8,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: ((context, index) {
                                      return Row(
                                        children: [
                                          AnimeCard(
                                              animeInfo: snapshot.data[index]),
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                        ],
                                      );
                                    }),
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount: 8,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: ((context, index) {
                                      return Row(
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor: Color.fromARGB(
                                                255, 136, 136, 136),
                                            highlightColor: Color.fromARGB(
                                                255, 102, 102, 102),
                                            child: Container(
                                              width: 100.0,
                                              height: 140.0,
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                        ],
                                      );
                                    }),
                                  );
                                }
                              },
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavbarIcon extends StatefulWidget {
  final IconData icon;
  bool isCurrent;
  NavbarIcon({Key? key, required this.icon, this.isCurrent = false})
      : super(key: key);

  @override
  State<NavbarIcon> createState() => _NavbarIconState();
}

class _NavbarIconState extends State<NavbarIcon> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return DpadContainer(
      onFocus: (isFocused) {
        setState(() {
          isSelected = isFocused;
        });
      },
      onClick: () {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.withOpacity(0.6) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color:
                widget.isCurrent ? Colors.white : Colors.white.withOpacity(0.7),
            size: 16.0,
          ),
        ),
      ),
    );
  }
}

class InfoButton extends StatefulWidget {
  final String id;
  const InfoButton({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
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
        print('Moving to info page');
        Get.to(InfoPage(anilistId: widget.id));
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.white) : null,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 24.0,
          ),
          margin: isSelected ? EdgeInsets.all(4.0) : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color.fromARGB(255, 58, 89, 183),
          ),
          child: Text(
            'INFO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimeCard extends StatefulWidget {
  final dynamic animeInfo;
  AnimeCard({Key? key, required this.animeInfo}) : super(key: key);

  @override
  State<AnimeCard> createState() => _AnimeCardState();
}

class _AnimeCardState extends State<AnimeCard> {
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
        Get.to(InfoPage(anilistId: widget.animeInfo['id']));
      },
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
        width: isSelected ? 120.0 : 100.0,
        height: isSelected ? 170.0 : 140.0,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: NetworkImage(
              widget.animeInfo['image'],
            ),
            fit: BoxFit.cover,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: AnimatedContainer(
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                    stops: [
                      0.4,
                      1.0,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )
                : null,
          ),
          child: isSelected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        widget.animeInfo['totalEpisodes'].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      width: 120.0,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        widget.animeInfo['title']['english'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
