import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_blocks/play_page.dart';
import 'package:splashscreen/splashscreen.dart';

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
        navigateAfterSeconds: MyHomePage(title: 'Music Blocks'),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
          title: Text(widget.title),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/images/avatar.png",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
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
                        imageId: Random().nextInt(6) + 1,
                        tag: "r1",
                      ),
                      RecommendedCard(
                        imageId: Random().nextInt(6) + 1,
                        tag: "r2",
                      ),
                      RecommendedCard(
                        imageId: Random().nextInt(6) + 1,
                        tag: "r3",
                      )
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
                      imageId: Random().nextInt(6) + 1,
                      tag: "h1",
                    ),
                    HotPlayCard(
                      imageId: Random().nextInt(6) + 1,
                      tag: "h2",
                    ),
                    HotPlayCard(
                      imageId: Random().nextInt(6) + 1,
                      tag: "h3",
                    ),
                    HotPlayCard(
                      imageId: Random().nextInt(6) + 1,
                      tag: "h4",
                    ),
                    HotPlayCard(
                      imageId: Random().nextInt(6) + 1,
                      tag: "h5",
                    ),
                    HotPlayCard(
                      imageId: Random().nextInt(6) + 1,
                      tag: "h6",
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
              Image.asset("assets/images/p$imageId.jpg",
                  height: 150, width: 300, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text("Sound of water", style: TextStyle(fontSize: 18)),
              ),
              Text("Denise Brewer", style: TextStyle(color: Colors.white70))
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
                  child: Image.asset("assets/images/p$imageId.jpg")),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("My Classic List",
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
