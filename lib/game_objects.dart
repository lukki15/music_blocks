import 'dart:math';

import 'package:music_blocks/utils.dart';
import 'package:music_blocks/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

class Blocks extends StatefulWidget {
  _BlocksState _blocksState;

  final BlockDroppedCallback blockDroppedCallback;
  final List<Tuple2<BlockType, Color>> blocksSelection;

  Blocks({this.blockDroppedCallback, this.blocksSelection});

  @override
  _BlocksState createState() {
    _blocksState = _BlocksState();
    return _blocksState;
  }

  void onBlockPlaced(BlockType blockType) {
    _blocksState?._onBlockPlaced(blockType);
  }

  List<Block> getDraggableBlocks() {
    return _blocksState?.draggableBlocks;
  }
}

class _BlocksState extends State<Blocks> {
  List<Block> availableBlocks = <Block>[];
  List<Block> draggableBlocks = <Block>[];

  List<Tuple2<BlockType, Color>> defaultAvailableBlocks =
      <Tuple2<BlockType, Color>>[
    Tuple2<BlockType, Color>(BlockType.SINGLE, Colors.lightGreenAccent),
    Tuple2<BlockType, Color>(BlockType.DOUBLE, Colors.lightBlueAccent),
    Tuple2<BlockType, Color>(BlockType.LINE_HORIZONTAL, Colors.redAccent),
    Tuple2<BlockType, Color>(BlockType.LINE_VERTICAL, Colors.brown),
    Tuple2<BlockType, Color>(BlockType.SQUARE, Colors.orangeAccent),
    Tuple2<BlockType, Color>(BlockType.TYPE_T, Colors.indigoAccent),
    Tuple2<BlockType, Color>(BlockType.TYPE_L, Colors.pinkAccent),
    Tuple2<BlockType, Color>(BlockType.MIRRORED_L, Colors.purpleAccent),
    Tuple2<BlockType, Color>(BlockType.TYPE_Z, Colors.amberAccent),
    Tuple2<BlockType, Color>(BlockType.TYPE_S, Colors.tealAccent),
  ];

  @override
  void initState() {
    super.initState();

    List<Tuple2<BlockType, Color>> blocksInfos;

    if (widget.blocksSelection == null || widget.blocksSelection.length == 0) {
      blocksInfos = defaultAvailableBlocks;
    } else {
      blocksInfos = widget.blocksSelection;
    }

    for (var blockInfo in blocksInfos) {
      availableBlocks.add(Block(blockInfo.item1, blockInfo.item2,
          blockSize: draggableBlockSize,
          blockDroppedCallback: widget.blockDroppedCallback,
          draggable: true));
    }

    populateDraggableBlocks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.center, child: draggableBlocks[0]),
          ),
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.center, child: draggableBlocks[1]),
          ),
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.center, child: draggableBlocks[2]),
          )
        ],
      ),
    );
  }

  void _onBlockPlaced(BlockType blockType) {
    draggableBlocks[draggableBlocks.indexWhere(
        (block) => block != null && block.blockType == blockType)] = null;

    //This means we have at least a block which can be placed
    if (!draggableBlocks.any((block) => block != null)) {
      populateDraggableBlocks();
    }
    setState(() {});
  }

  void populateDraggableBlocks() {
    availableBlocks.shuffle(Random());
    draggableBlocks.clear();
    for (int index = 0; index < 3; index++) {
      draggableBlocks.add(availableBlocks[index]);
    }
  }
}
