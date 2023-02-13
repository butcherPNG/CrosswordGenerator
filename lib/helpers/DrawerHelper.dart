


import 'dart:convert';
import 'dart:io';

import 'package:crosswordgen/classes/Crossword.dart';
import 'package:crosswordgen/classes/Description.dart';
import 'package:crosswordgen/classes/Tuple.dart';
import 'package:crosswordgen/crossword_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




List row = <Widget>[];
List<TextEditingController> controllers = List.generate(15 * 15, (index) => TextEditingController());

class MyDrawerHelper {

  
  List<GlobalKey> keys = [];
   getRowsInSquare(BuildContext context, double width, Crossword c) {

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
    int ctr = 0;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < coloumns; j++) {
        int pos = _contain(starts, i, j);

        horizontaStarts = pos == 0 ? horizontaStarts + 1 : horizontaStarts;
        verticalStarts = pos == 1 ? verticalStarts + 1 : verticalStarts;

        keys.add(GlobalKey());
        row.add(Square(
          id: ctr,
             border: Border.all(
                  color: Colors.black
              ),
            focus: FocusNode(),
            controller: controllers[ctr],
            left: ((lato * i) + border),
            top: ((lato * j) + topBorder),
            lato: lato - latoBordo,
            colore: board[i][j] == ' ' || board[i][j] == '*'
                ? Colors.black
                : Colors.white,
            txt: board[i][j],
            index: pos,
            onClick: pos == -1 ? () {} : () {
              print(pos);
            },
            ));
            ctr++;
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




  }





class Square extends StatefulWidget{
  final int id;
  Border? border;
 final FocusNode? focus;
 final TextEditingController? controller;
 final double left;
 final double top;
 final double lato;
 final Color colore;
 final String txt;
 final int index;
 final Function() onClick;

  Square({
    required this.id,
    required this.border,
    this.focus,
    this.controller,
    required this.left,
    required this.top,
    required this.lato,
    required this.colore,
    required this.txt,
    required this.index,
    required this.onClick,
  });


  @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square>{


   @override
   void initState() {
      // changeState(Border.all(color: Colors.green,));
     super.initState();
   }
  @override
  Widget build(BuildContext context){
    return BlocBuilder<CrosswordBloc, Map<int, Border>>(
        builder: (context, state){
          return Positioned(

        left: widget.left,
        top: widget.top,
        width: widget.lato,
        height: widget.lato,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: GestureDetector(
                onTap: widget.onClick,
                child: Container(
                  decoration: BoxDecoration(
                    border: widget.colore == Colors.black ? null :
                    state[widget.id],
                    color: widget.colore,
                  ),

                  child: Stack(children: <Widget>[
                    widget.onClick == null
                        ?  Positioned(
                      child: Container(),
                    )
                        :  Positioned(
                        left: 3,
                        top: 3,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: widget.index < 0 ? Text(
                              " ",
                              style: TextStyle(
                                  fontSize: 9.0, fontWeight: FontWeight.bold),
                            ) :
                            Text(
                              "${widget.index + 1}",
                              style: const TextStyle(
                                  fontSize: 9.0, fontWeight: FontWeight.bold),
                            )
                        )),
                    Positioned(
                      key: widget.key,
                      child: Align(
                        alignment: Alignment.center,
                        child: widget.colore == Colors.black ? Container() :
                        TextField(
                          focusNode: FocusNode(),
                          onChanged: (value){
                            print(widget.id);

                          },
                          controller: widget.controller,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]),
                ))));
  });
  }
}
// Widget _square(
//     Border border,
//     FocusNode? focus,
//     TextEditingController? controller,
//     double left,
//     double top,
//     double lato,
//     Color colore,
//     String txt,
//     int index,
//     Function() onClick,
//     ) {
