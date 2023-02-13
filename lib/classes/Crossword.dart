


import 'dart:math';

import 'package:crosswordgen/classes/Description.dart';

import 'Tuple.dart';

class Crossword {
  String letters = "abcdefghijklmnopqrstuvwxyz";
  final List<int> _dirX = [0, 1];
  final List<int> _dirY = [1, 0];
  List<List<String>>? _board;
  List<List<int>>? _hWords;
  List<List<int>>? _vWords;
  List<Description> descriptionsVert = [];
  List<Description> descriptionsHoriz = [];
  List<String>? usedWords;
  int index = 1;
  List<Tuple4<int, int, int, int>> _starts = [];

  int _nBlockInserted = 0;

  int? _n;
  int? _m;
  int _hCount = 0;
  int _vCount = 0;
  static Random? _rand;
  static List<String>? _wordsToInsert;
  static List<List<String>>? _tempBoard;
  static int? _bestSol;
  DateTime? initialTime;

  Crossword(int xDimen, int yDimen) {
    _n = xDimen;
    _m = yDimen;
    _rand = new Random();

    _board = List.filled(xDimen, List.filled(yDimen, ' '));
    _hWords = List.filled(xDimen, List.filled(yDimen, 0));
    _vWords = List.filled(xDimen, List.filled(yDimen, 0));

    usedWords = [];

    List<Tuple4<int, int, int, int>> _starts = [];

    for (var i = 0; i < _n!; i++) {
      _board![i] = List.filled(yDimen, ' ');
      _hWords![i] = List.filled(yDimen, 0);
      _vWords![i] = List.filled(yDimen, 0);

      for (var j = 0; j < _m!; j++) {
        _board![i][j] = ' ';
      }
    }
  }


  String toString() {
    return _board!.map((row) =>
        row.map((col) =>
        letters.contains(col) ? col : ' ').join('')).join('\n');
  }
  String getAt(int r, int c) => _board![r][c];

  void setAt(int r, int c, String value) => _board![r][c] = value;
  int getN() => _n!;
  int getM() => _m!;


  var inRTL;

  bool isValidPosition(int x, int y) {
    return x >= 0 && y >= 0 && x < _n! && y < _m!;
  }

  int canBePlaced(String word, int x, int y, int dir) {
    var result = 0;

    if (dir == 0) {
      for (var j = 0; j < word.length; j++) {
        int x1 = x, y1 = y + j;

        if (!isValidPosition(x1, y1)) return -1;
        if (_board![x1][y1] != ' ' && _board![x1][y1] != word[j]) return -1;
        if (isValidPosition(x1 - 1, y1) && _hWords![x1 - 1][y1] > 0) return -1;
        if (isValidPosition(x1 + 1, y1) && _hWords![x1 + 1][y1] > 0) return -1;
        if (_board![x1][y1] == word[j]) result++;
      }
    } else {
      for (var j = 0; j < word.length; j++) {
        int x1 = x + j, y1 = y;

        if (!isValidPosition(x1, y1)) return -1;
        if (_board![x1][y1] != ' ' && _board![x1][y1] != word[j]) return -1;
        if (isValidPosition(x1, y1 - 1) && _vWords![x1][y1 - 1] > 0) return -1;
        if (isValidPosition(x1, y1 + 1) && _vWords![x1][y1 + 1] > 0) return -1;
        if (_board![x1][y1] == word[j]) result++;
      }
    }

    int xStar = x - _dirX[dir], yStar = y - _dirY[dir];
    if (isValidPosition(xStar, yStar) &&
        (_board![xStar][yStar] != ' ' && _board![xStar][yStar] != '*')) return -1;

    xStar = x + _dirX[dir] * word.length;
    yStar = y + _dirY[dir] * word.length;
    if (isValidPosition(xStar, yStar) &&
        (_board![xStar][yStar] != ' ' && _board![xStar][yStar] != '*')) return -1;

    return result == word.length ? -1 : result;
  }


  void putWord(String word, int x, int y, int dir, int value, String? description) {
    if (usedWords!.contains(word)) return;
    var mat = dir == 0 ? _hWords : _vWords;
    var descriptions = dir == 0 ? descriptionsVert : descriptionsHoriz;
    descriptions.add(Description(description: description!, index: index));
    index++;
    usedWords!.add(word);
    _nBlockInserted++;
    _starts.add(Tuple4(x, y, dir, word.length));

    for (var i = 0; i < word.length; i++) {
      int x1 = x + _dirX[dir] * i, y1 = y + _dirY[dir] * i;
      _board![x1][y1] = word[i];
      mat![x1][y1] = value;
    }

    int xStar = x - _dirX[dir], yStar = y - _dirY[dir];
    if (isValidPosition(xStar, yStar)) _board![xStar][yStar] = '*';
    xStar = x + _dirX[dir] * word.length;
    yStar = y + _dirY[dir] * word.length;
    if (isValidPosition(xStar, yStar)) _board![xStar][yStar] = '*';
  }


  int addWord(String word, String description) {
    var info = bestPosition(word);
    if (info == null) return -1;

    var wordToInsert = word;
    var dir = info.Item3;
    var x = info.Item1;
    var y = info.Item2;

    if (dir == 0) {
      _hCount++;
    } else {
      _vCount++;
    }

    var value = dir == 0 ? _hCount : _vCount;
    putWord(wordToInsert, x, y, dir, value, description);
    return dir;
  }


  List<Tuple<int, int, int>>? findPositions(String word) {
    int max = 0;
    List<Tuple<int, int, int>> positions = [];

    for (int x = 0; x < _n!; x++) {
      for (int y = 0; y < _m!; y++) {
        for (int dir = 0; dir < _dirX.length; dir++) {
          int count = canBePlaced(word, x, y, dir);
          if (count < max) continue;
          if (count > max) positions.clear();

          max = count;
          positions.add(Tuple(x, y, dir));
        }
      }
    }
    return positions.isNotEmpty ? positions : null;
  }


  Tuple<int, int, int>? bestPosition(String word) {
    var positions = findPositions(word);
    if (positions!.isNotEmpty) {
      var index = _rand!.nextInt(positions.length);
      return positions[index];
    }
    return null;
  }
  bool isLetter(String a) => letters.contains(a);

  List<List<String>> getBoard() => _board!;

  void reset() {
    for (var i = 0; i < _n!; i++) {
      for (var j = 0; j < _m!; j++) {
        _board![i][j] = ' ';
        _vWords![i][j] = _hWords![i][j] = 0;
      }
    }
    _hCount = _vCount = 0;
  }


  void addWords(List<String> words) {
    _wordsToInsert = words;
    _bestSol = _n! * _m!;
    var currentTime = DateTime.now();
    generateSolution(0);
    _board = _tempBoard;
  }


  int freeSpaces() {
    int count = 0;
    for (int i = 0; i < getN(); i++) {
      for (int j = 0; j < getM(); j++) {
        if (_board![i][j] == ' ' || _board![i][j] == '*') count++;
      }
    }
    return count;
  }



  void generateSolution(int pos) {
    if (pos >= _wordsToInsert!.length ||
        (DateTime.now().difference(initialTime!)).inMinutes > 1) return;

    for (int i = pos; i < _wordsToInsert!.length; i++) {
      var posi = bestPosition(_wordsToInsert![i]);
      if (posi != null) {
        var word = _wordsToInsert![i];
        var value = posi.Item3 == 0 ? _hCount : _vCount;
        putWord(word, posi.Item1, posi.Item2, posi.Item3, value, '');
        generateSolution(pos + 1);
        removeWord(word, posi.Item1, posi.Item2, posi.Item3);
      } else {
        generateSolution(pos + 1);
      }
    }

    int c = freeSpaces();
    if (c >= _bestSol!) return;
    _bestSol = c;
    _tempBoard = List<List<String>>.from(_board!);
  }


  void removeWord(String word, int x, int y, int dir) {
    var mat = dir == 0 ? _hWords : _vWords;
    var mat1 = dir == 0 ? _vWords : _hWords;

    for (var i = 0; i < word.length; i++) {
      int x1 = x + _dirX[dir] * i, y1 = y + _dirY[dir] * i;
      if (mat1![x1][y1] == 0) _board![x1][y1] = ' ';
      mat![x1][y1] = 0;
    }

    int xStar = x - _dirX[dir], yStar = y - _dirY[dir];
    if (isValidPosition(xStar, yStar) && hasFactibleValueAround(xStar, yStar)) {
      _board![xStar][yStar] = ' ';
    }

    xStar = x + _dirX[dir] * word.length;
    yStar = y + _dirY[dir] * word.length;
    if (isValidPosition(xStar, yStar) && hasFactibleValueAround(xStar, yStar)) {
      _board![xStar][yStar] = ' ';
    }
  }

  bool hasFactibleValueAround(int x, int y) {
    for (var i = 0; i < _dirX.length; i++) {
      int x1 = x + _dirX[i], y1 = y + _dirY[i];
      if (isValidPosition(x1, y1) &&
          (_board![x1][y1] != ' ' || _board![x1][y1] == '*')) return true;
      x1 = x - _dirX[i];
      y1 = y - _dirY[i];
      if (isValidPosition(x1, y1) &&
          (_board![x1][y1] != ' ' || _board![x1][y1] == '*')) return true;
    }
    return false;
  }

  bool isCompleted() {
    return (getN() * getM()) - _nBlockInserted < 10;
  }

  List<Tuple4<int, int, int, int>>? getStarts() {
    return _starts;
  }
}