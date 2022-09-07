import 'dart:convert';

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inustream_android_tv/pages/info_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  String searchName = '';
  late FocusNode fn;
  bool isSelected = false;

  Future<dynamic> searchForAnime() async {
    var response = await http.get(Uri.parse(
        'https://consumet-api.herokuapp.com/meta/anilist/${searchName}'));
    return jsonDecode(response.body)['results'];
  }

  @override
  void initState() {
    fn = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff16151A),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: DpadContainer(
          onFocus: (isFocused) {
            setState(() {
              isSelected = isFocused;
            });
          },
          onClick: () {
            fn.requestFocus();
          },
          child: Column(
            children: [
              TextField(
                focusNode: fn,
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Search for an anime...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                onSubmitted: (value) {
                  setState(() {
                    searchName = value.replaceAll(' ', '-').toLowerCase();
                  });
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              FutureBuilder<dynamic>(
                future: searchForAnime(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: ((context, index) {
                          return snapshot.data[index]['status'] !=
                                  'Not yet aired'
                              ? AnimeSearchResult(
                                  animeData: snapshot.data[index])
                              : SizedBox.shrink();
                        }),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimeSearchResult extends StatefulWidget {
  final dynamic animeData;
  const AnimeSearchResult({Key? key, required this.animeData})
      : super(key: key);

  @override
  State<AnimeSearchResult> createState() => _AnimeSearchResultState();
}

class _AnimeSearchResultState extends State<AnimeSearchResult> {
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
        Get.to(InfoPage(anilistId: widget.animeData['id']));
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        color: isSelected ? Colors.grey.withOpacity(0.4) : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.deepPurple,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image(
                    image: NetworkImage(
                      widget.animeData['image'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.animeData['title']['english'] ??
                          widget.animeData['title']['native'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        Text(
                          'Episodes: ' +
                              widget.animeData['totalEpisodes'].toString() +
                              ' • ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Status: ' + widget.animeData['status'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}
