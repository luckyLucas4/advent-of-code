import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

enum Color { red, green, blue }

class GameCond {
  int maxRed = 0;
  int maxGreen = 0;
  int maxBlue = 0;
}

void run() async {
  final file = File('res/input2.txt');
  // Version 1
  int total1 = 0;
  int total2 = 0;
  int currentID = 1;
  List<GameCond> conds = await readConditions(file);
  for (GameCond c in conds) {
    if (c.maxRed <= 12 && c.maxGreen <= 13 && c.maxBlue <= 14) {
      total1 += currentID;
    }
    total2 += c.maxRed * c.maxGreen * c.maxBlue;
    currentID++;
  }
  print(total1);
  print(total2);
  // Version 2
  total1 = total2 = 0;
  currentID = 1;
  List<Map<Color, int>> colorMaxMap = await readConditions2(file);
  for (var c in colorMaxMap) {
    int maxRed = c[Color.red] ?? 0;
    int maxGreen = c[Color.green] ?? 0;
    int maxBlue = c[Color.blue] ?? 0;
    if (maxRed <= 12 && maxGreen <= 13 && maxBlue <= 14) {
      total1 += currentID;
    }
    total2 += maxRed * maxGreen * maxBlue;
    currentID++;
  }
  print(total1);
  print(total2);
}

class ColorPos {
  int index;
  Color color;
  ColorPos(this.index, this.color);
}

Future<List<Map<Color, int>>> readConditions2(File file) async {
  final List<Map<Color, int>> result = [];
  final Map<Color, RegExp> colorExp = {
    Color.green: RegExp(r'green'),
    Color.blue: RegExp(r'blue'),
    Color.red: RegExp(r'red'),
  };
  var number = RegExp(r'\b[0-9]+\b');
  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());
  final queue = PriorityQueue<ColorPos>((a, b) => a.index.compareTo(b.index));
  Map<Color, int> valueMap = {};
  await for (String line in lines) {
    queue.clear();
    valueMap.clear();
    for (var e in colorExp.entries) {
      for (Match m in e.value.allMatches(line)) {
        queue.add(ColorPos(m.start, e.key));
      }
    }
    int counter = 0;
    var colorPositions = queue.toList();
    for (Match m in number.allMatches(line)) {
      // Skip "Game #""
      if (counter == 0) {
        counter++;
        continue;
      }
      Color c = colorPositions[counter - 1].color;
      int number = int.tryParse(line.substring(m.start, m.end))!;
      valueMap[c] = max(number, valueMap[c] ?? 0);
      counter++;
    }
    result.add(Map<Color, int>.of(valueMap));
  }

  return result;
}

Future<List<GameCond>> readConditions(File file) async {
  final List<GameCond> result = [];
  var red = RegExp(r'red');
  var green = RegExp(r'green');
  var blue = RegExp(r'blue');
  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());

  await for (String line in lines) {
    var currentGame = GameCond();
    for (Match m in green.allMatches(line)) {
      currentGame.maxGreen =
          max(currentGame.maxGreen, extractInt(line, m.start - 2)!);
    }
    for (Match m in red.allMatches(line)) {
      currentGame.maxRed =
          max(currentGame.maxRed, extractInt(line, m.start - 2)!);
    }
    for (Match m in blue.allMatches(line)) {
      currentGame.maxBlue =
          max(currentGame.maxBlue, extractInt(line, m.start - 2)!);
    }
    result.add(currentGame);
    // int startIndex = intro.firstMatch(line)!.end;
    // var rounds = line.substring(startIndex).split(';');
    // for (String r in rounds) {}
  }

  return result;
}

int? extractInt(String s, int end) {
  int start = lastSpaceChar(s, end);
  var numStr = s.substring(start, end + 1);
  return int.tryParse(numStr);
}

int lastSpaceChar(String s, int startIndex) {
  int counter = 0;
  while (startIndex - counter > 0) {
    counter++;
    if (s[startIndex - counter] == ' ') {
      return startIndex - counter + 1;
    }
  }
  return -1;
}
