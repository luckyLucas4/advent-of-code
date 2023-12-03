import 'dart:convert';
import 'dart:io';

class Coord {
  int x, y;
  Coord(this.x, this.y);
}

class Star {
  Coord coord;
  List<int> adjecentNums = [];
  Star(this.coord);
}

class SymbolsAndWordsAndStars {
  List<Coord> symbolCoords;
  List<Star> stars;
  Map<Coord, String> wordCoords;
  SymbolsAndWordsAndStars(this.symbolCoords, this.stars, this.wordCoords);
}

void run() async {
  var result = 0;
  var result2 = 0;
  final file = File('res/input3.txt');
  SymbolsAndWordsAndStars r = await getData(file);
  for (var e in r.wordCoords.entries) {
    for (var coord in r.symbolCoords) {
      if (isAdjecent(coord, e.key, e.value)) {
        result += int.tryParse(e.value)!;
        break;
      }
    }
  }
  for (var star in r.stars) {
    for (var e in r.wordCoords.entries) {
      if (isAdjecent(star.coord, e.key, e.value)) {
        star.adjecentNums.add(int.tryParse(e.value)!);
      }
    }
  }
  for (var star in r.stars) {
    if (star.adjecentNums.length == 2) {
      result2 += star.adjecentNums[0] * star.adjecentNums[1];
    }
  }
  print(result);
  print(result2);
}

bool isAdjecent(Coord symbol, Coord wordStart, String word) {
  if (symbol.y >= (wordStart.y - 1) && symbol.y <= (wordStart.y + 1)) {
    if (symbol.x >= (wordStart.x - 1) &&
        symbol.x <= (wordStart.x + word.length)) {
      return true;
    }
  }
  return false;
}

Future<SymbolsAndWordsAndStars> getData(File file) async {
  final List<Coord> symbolCoords = [];
  final List<Star> stars = [];
  final Map<Coord, String> numStringCoords = {};
  var symbol = RegExp(r'[^0-9|\.]');
  var number = RegExp(r'\b[0-9]+\b');
  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());
  var y = 0;
  await for (String line in lines) {
    for (Match m in symbol.allMatches(line)) {
      symbolCoords.add(Coord(m.start, y));
      if (line[m.start] == '*') {
        stars.add(Star(Coord(m.start, y)));
      }
    }
    for (Match m in number.allMatches(line)) {
      numStringCoords[Coord(m.start, y)] = line.substring(m.start, m.end);
    }
    y++;
  }
  return SymbolsAndWordsAndStars(symbolCoords, stars, numStringCoords);
}
