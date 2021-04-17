import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_blocks/play_page.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:music_blocks/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Blocks',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(
        seconds: 3,
        //seconds: 1,
        backgroundColor: Colors.black,
        image: Image.asset("assets/loading_music_node_outOfOrder.gif"),
        loaderColor: Colors.white,
        photoSize: 150.0,
        navigateAfterSeconds: MainMenu(title: 'Music Blocks'),
        /*
        navigateAfterSeconds: PagePlay(
          imageId: 1,
          tag: "test",
        ),
        */
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  final String title;

  MainMenu({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset("assets/music_logo.png",
                      width: 300, height: 300, fit: BoxFit.contain),
                )),
            Expanded(
                flex: 2,
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.play_circle_outline),
                    iconSize: 200,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MyHomePage(title: this.title)),
                      );
                    },
                  ),
                )),
            Expanded(
                child: Center(
              child: Text("by LUKKI15 and LEON KERNER"),
            ))
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  AudioPlayer audioPlayer = new AudioPlayer();

  bool backgroundMusicIsPlaying = false;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  Future<int> _startBackgroundMusic() async {
    if (!backgroundMusicIsPlaying) {
      backgroundMusicIsPlaying = true;
      audioPlayer.setReleaseMode(ReleaseMode.LOOP);
      return audioPlayer.play("assets/assets/music/Duckpond_Titelmusik.mp3",
          isLocal: true, volume: 0.5);
    }
  }

  Future<int> _pauseBackgroundMusic() async {
    return audioPlayer.pause();
  }

  Future<int> _resumeBackgroundMusic() async {
    return audioPlayer.resume();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    widget._startBackgroundMusic();

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: ClipRRect(
                child: Image.asset(
                  "assets/music_logo.png",
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text("Starter Playlist",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      RecommendedCard(
                        imageId: 0,
                        tag: "r1",
                      ),
                      RecommendedCard(
                        imageId: 1,
                        tag: "r2",
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Text("Hot Playlists",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Spacer(),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "View All",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                          onSurface: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: [
                    HotPlayCard(
                      imageId: 2,
                      tag: "h1",
                    ),
                    HotPlayCard(
                      imageId: 3,
                      tag: "h2",
                    ),
                    HotPlayCard(
                      imageId: 4,
                      tag: "h3",
                    ),
                    HotPlayCard(
                      imageId: 5,
                      tag: "h4",
                    ),
                    HotPlayCard(
                      imageId: 6,
                      tag: "h5",
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class RecommendedCard extends StatelessWidget {
  final int imageId;
  final String tag;
  RecommendedCard({this.imageId, this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PagePlay(
                    tag: this.tag,
                    imageId: this.imageId,
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/" + images[imageId],
                  height: 150, width: 300, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child:
                    Text(musikTitle[imageId], style: TextStyle(fontSize: 18)),
              ),
              Text("", style: TextStyle(color: Colors.white70))
            ],
          ),
        ),
      ),
    );
  }
}

class HotPlayCard extends StatelessWidget {
  final int imageId;
  final String tag;
  HotPlayCard({this.imageId, this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PagePlay(
                    tag: this.tag,
                    imageId: this.imageId,
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: this.tag,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/images/" + images[imageId])),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(musikTitle[imageId],
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Icon(Icons.favorite),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("250", style: TextStyle(color: Colors.white70)),
                  ),
                  Spacer(),
                  Icon(Icons.details),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("10", style: TextStyle(color: Colors.white70)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
