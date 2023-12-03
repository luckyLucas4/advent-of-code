import 'dart:convert';
import 'dart:io';

class Coord {
  int x, y;
  Coord(this.x, this.y);
}

class SymbolsAndWords {
  List<Coord> symbolCoords;
  Map<Coord, String> wordCoords;
  SymbolsAndWords(this.symbolCoords, this.wordCoords);
}

void run() async {
  var result = 0;
  final file = File('res/input3test.txt');
  SymbolsAndWords r = await getData(file);
  List<Coord> symbolCoords = r.symbolCoords;
  Map<Coord, String> numStringCoords = r.wordCoords;
  
}

Future<SymbolsAndWords> getData(File file) async {
  final List<Coord> symbolCoords = [];
  final Map<Coord, String> numStringCoords = {};
  var symbol = RegExp(r'[^0-9|\.]');
  var number = RegExp(r'\b[0-9]+\b');
  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());
  var y = 0;
  await for (String line in lines) {
    for (Match m in symbol.allMatches(line)) {
      symbolCoords.add(Coord(m.start, y));
    }
    for (Match m in number.allMatches(line)) {
      numStringCoords[Coord(m.start, y)] = line.substring(m.start, m.end);
    }
    y++;
  }
  return SymbolsAndWords(symbolCoords, numStringCoords);
}
