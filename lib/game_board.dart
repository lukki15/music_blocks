import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_blocks/utils.dart';
import 'package:music_blocks/block.dart';

class GameBoard extends StatefulWidget {
  _GameBoardState _gameBoardState;

  final numOfColumns = 8;

  final BlockPlacedCallback blockPlacedCallback;
  final OutOfBlocksCallback outOfBlocksCallback;
  final RowsClearedCallback rowsClearedCallback;

  GameBoard(
      {this.blockPlacedCallback,
      this.outOfBlocksCallback,
      this.rowsClearedCallback});

  @override
  _GameBoardState createState() => _GameBoardState();

  void onBlockDropped(
      BlockType blockType, Color blockColor, Offset blockPosition) {
    _gameBoardState?.onBlockDropped(blockType, blockColor, blockPosition);
  }

  void setAvailableDraggableBlocks(List<Block> availableDraggableBlocks) {
    _gameBoardState?.computeAvailableBlocks(availableDraggableBlocks);
  }
}

class _GameBoardState extends State<GameBoard> {
  List<Widget> cells = <Widget>[];
  List<Color> cellColorsList = <Color>[];
  List<Rect> gridBlockRectangleList;

  final margin = 8.0;

  void onBlockDropped(
      BlockType blockType, Color blockColor, Offset blockPosition) {
    //cellsToClear.clear();
    int numOfChildBlocks = getUnitBlocksCount(blockType);

    //Find the grid block positions where the dragged blocks can be placed
    List<int> cellsToFill = computeFillableGridBlockPositions(
        numOfChildBlocks, blockType, blockPosition);

    //Color the blocks with the dragged ones
    if (cellsToFill.length == numOfChildBlocks) {
      for (int index in cellsToFill) {
        cellColorsList[index] = blockColor;
      }

      if (widget.blockPlacedCallback != null) {
        widget.blockPlacedCallback(blockType);
      }
      setState(() {});
    }
  }

  void computeAvailableBlocks(List<Block> availableDraggableBlocks) {
    bool outOfBlocks = true;
    for (Block draggableBlock in availableDraggableBlocks) {
      int numOfChildBlocks = getUnitBlocksCount(draggableBlock.blockType);

      List<int> cellsToFill;
      for (Rect gridBlockRectangle in gridBlockRectangleList) {
        cellsToFill = computeFillableGridBlockPositions(numOfChildBlocks,
            draggableBlock.blockType, gridBlockRectangle.topLeft);
        if (numOfChildBlocks == cellsToFill.length) {
          outOfBlocks = false;
          break;
        }
      }
      if (!outOfBlocks) {
        break;
      }
    }

    if (outOfBlocks && widget.outOfBlocksCallback != null) {
      widget.outOfBlocksCallback(context);
    }
  }

  List<int> computeFillableGridBlockPositions(
      int numOfChildBlocks, BlockType blockType, Offset droppedBlockPosition) {
    Rect gridBlockRectangle;
    List<int> cellsToFill = <int>[];
    List<Rect> droppedBlockRects =
        getDroppedBlocks(blockType, droppedBlockPosition);

    for (Rect droppedBlockRect in droppedBlockRects) {
      double maxIntersection = 0.0;
      int matchedIndex = -1;
      if (cellsToFill.length == numOfChildBlocks) {
        break;
      }
      for (int col = 0; col < gridBlockRectangleList.length; col++) {
        gridBlockRectangle = gridBlockRectangleList[col];

        if (droppedBlockRect.overlaps(gridBlockRectangle)) {
          Rect intersect = droppedBlockRect.intersect(gridBlockRectangle);
          double overlapArea = intersect.width * intersect.height;
          if (maxIntersection == 0.0 || overlapArea >= maxIntersection) {
            matchedIndex = col;
          }
          maxIntersection = max(overlapArea, maxIntersection);
        }
      }
      if (matchedIndex >= 0 &&
          cellColorsList[matchedIndex] == emptyCellColor &&
          !cellsToFill.contains(matchedIndex)) {
        cellsToFill.add(matchedIndex);
      }
    }
    return cellsToFill;
  }

  List<TableRow> _createGridCells() {
    List<TableRow> rows = <TableRow>[];
    for (int row = 0; row < widget.numOfColumns; row++) {
      rows.add(TableRow(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getRow(row),
        ),
      ]));
    }
    return rows;
  }

  List<Widget> getRow(int rowIdx) {
    List<Block> row = <Block>[];
    for (int col = 0; col < widget.numOfColumns; col++) {
      row.add(cells[rowIdx * widget.numOfColumns + col]);
    }
    return row;
  }

  void computeCells() {
    for (int i = 0; i < widget.numOfColumns * widget.numOfColumns; i++) {
      cellColorsList.add(emptyCellColor);
    }

    cells.clear();
    for (int row = 0; row < widget.numOfColumns * widget.numOfColumns; row++) {
      cells.add(Block(BlockType.SINGLE, cellColorsList[row]));
    }

    gridBlockRectangleList = <Rect>[];
    for (int col = 0; col < cells.length; col++) {
      gridBlockRectangleList.add(Rect.fromLTWH(
          col % widget.numOfColumns * blockUnitSizeWithPadding,
          col ~/ widget.numOfColumns * blockUnitSizeWithPadding,
          blockUnitSize,
          blockUnitSize));
    }
  }

  List<Rect> getDroppedBlocks(
      BlockType blockType, Offset droppedBlockPosition) {
    List<Rect> droppedBlocks = <Rect>[];
    RenderBox getBox = context.findRenderObject();
    droppedBlockPosition =
        getBox.globalToLocal(droppedBlockPosition) - Offset(margin, margin);
    switch (blockType) {
      case BlockType.SINGLE:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        break;
      case BlockType.DOUBLE:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.LINE_HORIZONTAL:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + 2 * blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.LINE_VERTICAL:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.SQUARE:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.TYPE_T:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + 2 * blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.TYPE_L:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.MIRRORED_L:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.TYPE_Z:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + 2 * blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.TYPE_S:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx + blockUnitSize,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + 2 * blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
    }
    return droppedBlocks;
  }

  @override
  Widget build(BuildContext context) {
    computeCells();
    return Container(
      width: widget.numOfColumns * blockUnitSizeWithPadding * 1.0,
      height: widget.numOfColumns * blockUnitSizeWithPadding * 1.0,
      child: Table(
        children: _createGridCells(),
      ),
    );
  }
}
