import 'dart:convert';
import 'dart:io';
import 'dart:math';

class GameCond {
  int maxRed = 0;
  int maxGreen = 0;
  int maxBlue = 0;
}

void run() async {
  int total1 = 0;
  int total2 = 0;
  final file = File('res/input2.txt');
  List<GameCond> conds = await readConditions(file);
  int currentID = 1;
  for (GameCond c in conds) {
    if (c.maxRed <= 12 && c.maxGreen <= 13 && c.maxBlue <= 14) {
      total1 += currentID;
    }
    total2 += c.maxRed * c.maxGreen * c.maxBlue;
    currentID++;
  }
  print(total1);
  print(total2);
}

Future<List<GameCond>> readConditions(File file) async {
  final List<GameCond> result = [];
  //var intro = RegExp(r'Game .:');
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
