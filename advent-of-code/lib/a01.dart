import 'dart:io';
import 'dart:convert';
import 'dart:async';

void run() async {
  List<String> numbersStrings = await getNumbers2();
  int total = 0;
  for (var s in numbersStrings) {
    int? val = int.tryParse(s);
    if (val == null) {
      print('Can\'t parse string $s, current total $total');
    } else {
      total += val;
    }
  }

  print(total.toString());
}

Future<List<String>> getNumbers1() async {
  final List<String> result = [];
  final file = File('res/input1.txt');
  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());
  try {
    await for (String line in lines) {
      final splitted = line.split('');
      isNum(s) => int.tryParse(s) != null;
      var first = splitted.firstWhere((s) => isNum(s));
      var last = splitted.lastWhere((s) => isNum(s));
      result.add(first + last);
    }
  } catch (e) {
    print('Error: $e');
  }
  return result;
}

Future<List<String>> getNumbers2() async {
  List<String> numberStrings = [
    r'one',
    r'two',
    r'three',
    r'four',
    r'five',
    r'six',
    r'seven',
    r'eight',
    r'nine',
  ];
  Map<int, RegExp> wordToNum = {};
  for (var i = 1; i <= 9; i++) {
    wordToNum[i] = RegExp(numberStrings[i - 1]);
  }

  final List<String> result = [];
  final file = File('res/input1.txt');
  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());
  try {
    await for (String line in lines) {
      for (int i in wordToNum.keys) {
        int c = 0;
        for (Match m in wordToNum[i]!.allMatches(line)) {
          line = line.substring(0, m.start + c) +
              i.toString() +
              line.substring(m.start + c, line.length);
          c++;
        }
      }

      final splitLine = line.split('');
      isNum(s) => int.tryParse(s) != null;
      var first = splitLine.firstWhere((s) => isNum(s));
      var last = splitLine.lastWhere((s) => isNum(s));
      result.add(first + last);
    }
  } catch (e) {
    print('Error: $e');
  }
  return result;
}
