import 'package:flutter/material.dart';
import 'package:music_blocks/block.dart';
import 'package:music_blocks/game_board.dart';
import 'package:music_blocks/game_objects.dart';
import 'package:music_blocks/utils.dart';
import 'package:tuple/tuple.dart';

class PagePlay extends StatefulWidget {
  final int imageId;
  final String tag;
  final bool alreadySolved;

  final Future<void> Function() stopBackgroundMusic;
  final Future<void> Function(int) playMusic;
  final void Function(int) solvedCallback;

  Blocks _gameObjects;
  GameBoard _gameBoard;

  PagePlay(
      {this.imageId,
      this.tag,
      this.stopBackgroundMusic,
      this.playMusic,
      this.solvedCallback,
      this.alreadySolved});

  @override
  _PagePlayState createState() => _PagePlayState();
}

class _PagePlayState extends State<PagePlay> {
  bool melodiePlaying = false;
  bool solvedPuzzel = false;

  Widget _buildGameBoard() {
    int numOfColumns = widget.imageId < 2 ? (widget.imageId + 2) : 8;
    widget._gameBoard = GameBoard(
      numOfColumns: numOfColumns,
      blockPlacedCallback: onBlockPlaced,
      outOfBlocksCallback: null,
      //rowsClearedCallback: rowsClearedCallback,
      solvedPuzzleCallback: solvedPuzzleCallback,
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

  void solvedPuzzleCallback() async {
    setState(() {
      solvedPuzzel = true;
    });
    await toggelMelodie();
    widget.solvedCallback(widget.imageId);
  }

  Widget _buildBottomSection() {
    List<Tuple2<BlockType, Color>> availableBlocks;

    switch (widget.imageId) {
      case 0:
        availableBlocks = <Tuple2<BlockType, Color>>[
          Tuple2<BlockType, Color>(BlockType.SQUARE, Colors.orangeAccent),
          Tuple2<BlockType, Color>(BlockType.TYPE_T, Colors.indigoAccent),
          Tuple2<BlockType, Color>(BlockType.TYPE_L, Colors.pinkAccent),
        ];
        break;
      case 1:
        availableBlocks = <Tuple2<BlockType, Color>>[
          Tuple2<BlockType, Color>(BlockType.LINE_VERTICAL, Colors.brown),
          Tuple2<BlockType, Color>(BlockType.SQUARE, Colors.orangeAccent),
          Tuple2<BlockType, Color>(BlockType.DOUBLE, Colors.lightBlueAccent),
        ];
        break;
      default:
        availableBlocks = [];
    }

    if (widget._gameObjects == null) {
      widget._gameObjects = Blocks(
        blockDroppedCallback: onBlockDropped,
        blocksSelection: availableBlocks,
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

  Future<void> toggelMelodie() async {
    if (!solvedPuzzel && !widget.alreadySolved) {
      return;
    }

    await widget.stopBackgroundMusic();

    if (melodiePlaying) {
      await widget.playMusic(-1);
    } else {
      await widget.playMusic(widget.imageId);
    }

    setState(() {
      melodiePlaying = !melodiePlaying;
    });
  }

  IconData melodyControlIcon() {
    if (!solvedPuzzel && !widget.alreadySolved) {
      return Icons.lock_outlined;
    } else if (melodiePlaying) {
      return Icons.pause_circle_outline;
    } else {
      return Icons.play_circle_outline;
    }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [Icon(Icons.add), Spacer(), Icon(Icons.details)],
              ),
              _buildGameBoard(),
              _buildBottomSection(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text(
                      musikTitle[widget.imageId],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              /*
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text("0:00"),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.pink,
                        min: 0,
                        max: 100,
                        value: 0,
                        onChanged: (_) {},
                      ),
                    ),
                    Text("0:00")
                  ],
                ),
              ),
              */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(melodyControlIcon()),
                      iconSize: 50,
                      onPressed: toggelMelodie),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
