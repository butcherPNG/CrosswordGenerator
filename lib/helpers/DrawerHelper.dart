


import 'package:crosswordgen/classes/Crossword.dart';
import 'package:crosswordgen/classes/Tuple.dart';
import 'package:flutter/material.dart';


class MyDrawerHelper {
  static getRowsInSquare(BuildContext context, double width, Crossword c) {
    var row = <Widget>[];

    const int percBorder = 25;
    const int topBorder = 25;
    const int percSquareBorder = 5;

    final int rows = c.getN();
    final int coloumns = c.getM();

    double width = MediaQuery.of(context).size.width;
    double border = width * percBorder / 100.0;

    double lato = (width - (border * 2)) / rows;
    double latoBordo = lato * percSquareBorder / 100.0;

    var board = c.getBoard();

    int horizontaStarts = 0, verticalStarts = 0;

    List<Tuple4<int, int, int, int>> starts = c.getStarts()!;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < coloumns; j++) {
        int pos = _contain(starts, i, j);

        horizontaStarts = pos == 0 ? horizontaStarts + 1 : horizontaStarts;
        verticalStarts = pos == 1 ? verticalStarts + 1 : verticalStarts;

        row.add(_square(
            ((lato * i) + border),
            ((lato * j) + topBorder),
            lato - latoBordo,
            board[i][j] == ' ' || board[i][j] == '*'
                ? Colors.black
                : Colors.white,
            board[i][j],
            pos == -1 ? () {} : () {
              print(pos);
            }
            ));
      }
    }

    return row;
  }

  static int _contain(List<Tuple4<int, int, int, int>> list, int x, int y) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].Item1 == x && list[i].Item2 == y) {
        return i;
      }
    }
    return -1;
  }

  static Widget _square(
      double left,
      double top,
      double lato,
      Color colore,
      String txt,
      Function() onClick,
      ) {
    return Positioned(
        left: left,
        top: top,
        width: lato,
        height: lato,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: GestureDetector(
                onTap: onClick,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    ),
                    color: colore,
                  ),

                  child: Stack(children: <Widget>[
                    onClick == null
                        ?  Positioned(
                      child: Container(),
                    )
                        :  Positioned(
                        left: 3,
                        top: 3,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "1",
                            style: TextStyle(
                                fontSize: 7.0, fontWeight: FontWeight.bold),
                          ),
                        )),
                    new Positioned(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          txt.toUpperCase(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]),
                ))));
  }
}