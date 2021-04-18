import 'package:flutter/material.dart';
import 'package:music_blocks/block.dart';

const Color screenBgColor = Colors.black87;
const Color emptyCellColor = Colors.white70;
const double draggableBlockSize = 30.0;
const double blockUnitSize = 35.0;
const double blockUnitSizeWithPadding = blockUnitSize + 2.0;
const int pointsPerMatchedRow = 10;
const int pointsPerBlockUnitPlaced = 1;

List<String> images = <String>[
  "maria_01.jpeg",
  "maria_02.jpeg",
  "maria_03.jpeg",
  "maria_04.jpeg",
  "pexels-lucas-allmann-442540.jpg",
  "pexels-ruca-souza-1049690.jpg",
  "pexels-victor-freitas-733767.jpg"
];

List<String> musikTitle = <String>[
  "Introduction",
  "Game Play",
  "Func",
  "Big Band",
  "Free Style",
  "Fusion",
  "Ska"
];

List<String> musik = <String>[
  "Freejazz.mp3",
  "Jazzfunk.mp3",
  "Jazztronica.mp3",
  "Latin.mp3",
  "Freejazz.mp3",
  "Jazzfunk.mp3",
  "Jazztronica.mp3",
];

typedef BlockPlacedCallback = void Function(BlockType blockType);
typedef OutOfBlocksCallback = void Function(BuildContext context);
typedef RowsClearedCallback = void Function(int numOfLines);
typedef PlayCallback = void Function();

int getUnitBlocksCount(BlockType blockType) {
  switch (blockType) {
    case BlockType.SINGLE:
      return 1;
    case BlockType.DOUBLE:
      return 2;
    case BlockType.LINE_HORIZONTAL:
    case BlockType.LINE_VERTICAL:
      return 3;
    case BlockType.SQUARE:
    case BlockType.TYPE_L:
    case BlockType.MIRRORED_L:
    case BlockType.TYPE_Z:
    case BlockType.TYPE_S:
      return 4;
    case BlockType.TYPE_T:
      return 5;
    default:
      return 0;
  }
}
