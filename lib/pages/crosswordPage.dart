

import 'dart:convert';
import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crosswordgen/crossword_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:crosswordgen/classes/Crossword.dart';
import 'package:crosswordgen/helpers/DrawerHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CrosswordPage extends StatefulWidget {
  String id;

  CrosswordPage({
    @pathParam required this.id,

  });

  Crossword? c;

  @override
  _CrosswordPageState createState() => _CrosswordPageState();
}

class _CrosswordPageState extends State<CrosswordPage> {
  List<String> wordsDescriptions = [];
  List<String> wordsDescriptionsHoriz = [];
  List<String> wordsDescriptionsVert = [];
  String? jsonList;
  String? jsonString;
  Future<void> getJson() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      jsonList = prefs.getString(widget.id)!;

      return Future.value(jsonList!)
          .then(parseWords);

  }

  @override
  void initState() {
    getJson();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    widget.c = Crossword(15, 15);
    widget.c!.reset();



    return BlocProvider<CrosswordBloc>(
        create: (context) => CrosswordBloc(),
        child: FutureBuilder(
            // future: _read(context, 'data/data2.json').then(parseWords),
            future: getJson(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                double width = MediaQuery.of(context).size.width;
                double height = MediaQuery.of(context).size.height;

                print(" Cruciverba : \n " + widget.c.toString());
                MyDrawerHelper myDrawerHelper = MyDrawerHelper();
                var row = myDrawerHelper.getRowsInSquare(context, width, widget.c!);


                return Scaffold(
                    body: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: row,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  BlocProvider.of<CrosswordBloc>(context).add(CrosswordCheckEvent());
                                },
                                child: Text('Check')
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Слова по вертикали:", style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(
                                        width: 200,
                                        height: 500,
                                        child: Expanded(
                                          child: ListView.builder(
                                              itemCount: widget.c!.descriptionsVert.length,
                                              itemBuilder: (context, index){
                                                return Text("${widget.c!.descriptionsVert[index].index}. ${widget.c!.descriptionsVert[index].description}");
                                              }
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Слова по горизонтали:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(
                                        width: 200,
                                        height: 500,
                                        child: Expanded(
                                          child: ListView.builder(
                                              itemCount: widget.c!.descriptionsHoriz.length,
                                              itemBuilder: (context, index){
                                                return Text("${widget.c!.descriptionsHoriz[index].index}. ${widget.c!.descriptionsHoriz[index].description}");
                                              }
                                          ),
                                        )
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                    )

                );
              } else {
                return Scaffold(
                    body: Center(
                      child: new SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: new CircularProgressIndicator(
                          value: null,
                          strokeWidth: 7.0,
                        ),
                      ),
                    ));
              }
            }),
    );
  }

  void actualizeData() {
    var count = widget.c!.getN() * widget.c!.getM();

    var board = widget.c!.getBoard();
    var p = 0;

    for (var i = 0; i < widget.c!.getN(); i++) {
      for (var j = 0; j < widget.c!.getM(); j++) {
        var letter = board[i][j] == '*' ? ' ' : board[i][j];

        if (letter != ' ') count--;

        p++;
      }
    }
  }

  Future<void> parseWords(String s) async {
    List<dynamic> data;

    data = json.decode(s);

    int i = 0;



    data.forEach((record) {

      String parola = record["name"].toString().toLowerCase();
      String description = record["description"].toString().toLowerCase();
      if (!widget.c!.isCompleted() /*i++ < 9000*/) {

        if (widget.c!.addWord(parola, description) == 0) {

          // orrizzontale
        } else if (widget.c!.addWord(parola, description) == 1) {

          // verticale
        } else {
          // non usata
        }
      } else {
        return;
      }

    });

    actualizeData();
  }

  Future<String> _read(BuildContext context, String name) async {
    return await DefaultAssetBundle.of(context).loadString(p.join('$name'));
    // .then(parseWords);
  }
}