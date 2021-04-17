import 'package:flutter/material.dart';
import 'package:music_blocks/block.dart';
import 'package:music_blocks/game_board.dart';
import 'package:music_blocks/game_objects.dart';
import 'package:music_blocks/utils.dart';

class PagePlay extends StatefulWidget {
  final int imageId;
  final String tag;

  final Future<int> Function() stopBackgroundMusic;
  final Future<int> Function(int) playMusic;

  Blocks _gameObjects;
  GameBoard _gameBoard;

  PagePlay({this.imageId, this.tag, this.stopBackgroundMusic, this.playMusic});

  @override
  _PagePlayState createState() => _PagePlayState();
}

class _PagePlayState extends State<PagePlay> {
  Widget _buildGameBoard() {
    int numOfColumns = widget.imageId < 2 ? (widget.imageId + 2) : 8;
    widget._gameBoard = GameBoard(
      numOfColumns: numOfColumns,
      blockPlacedCallback: onBlockPlaced,
      outOfBlocksCallback: null,
      //rowsClearedCallback: rowsClearedCallback,
    );
    return widget._gameBoard;
  }

  void onBlockPlaced(BlockType blockType) {
    widget._gameObjects?.onBlockPlaced(blockType);
    //_currentScore += getUnitBlocksCount(blockType) * pointsPerBlockUnitPlaced;
    //_scoreBoard?.updateScoreboard(_currentScore);
  }

  void outOfBlocksCallback(BuildContext context) {
    //_gameTimer?.stop();
    //saveSessionStats();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => _createGameOverDialog(context));
  }

  Widget _buildBottomSection() {
    if (widget._gameObjects == null) {
      widget._gameObjects = Blocks(
        blockDroppedCallback: onBlockDropped,
      );
    }
    return widget._gameObjects;
  }

  void onBlockDropped(
      BlockType blockType, Color blockColor, Offset blockPosition) {
    widget._gameBoard?.onBlockDropped(blockType, blockColor, blockPosition);
    widget._gameBoard?.setAvailableDraggableBlocks(widget._gameObjects
        ?.getDraggableBlocks()
        ?.where((block) => block != null)
        ?.toList());
  }

  Widget _createGameOverDialog(BuildContext context) {
    return WillPopScope(
        onWillPop: () {},
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container())); // TODO GAME_OVER
  }

  void playMelodie() async {
    await widget.stopBackgroundMusic();
    widget.playMusic(widget.imageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Now Playing"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Hero(
              tag: widget.tag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/images/" + images[widget.imageId],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Row(
                children: [Icon(Icons.add), Spacer(), Icon(Icons.details)],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _buildGameBoard(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _buildBottomSection(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text(
                      musikTitle[widget.imageId],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("Leon Kerner")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text("1:20"),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.pink,
                        min: 0,
                        max: 100,
                        value: 30,
                        onChanged: (_) {},
                      ),
                    ),
                    Text("5:30")
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_left, size: 50),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.play_circle_outline,
                      ),
                      iconSize: 50,
                      onPressed: playMelodie),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.arrow_right,
                    size: 50,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
