import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:crosswordgen/classes/Crossword.dart';
import 'package:crosswordgen/helpers/DrawerHelper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  Crossword? c;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String fileReaded;

  @override
  void initState() {
    widget.c = new Crossword(10, 10);
    widget.c!.reset();
    _read(context, "data/data2.json").then(parseWords);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    widget.c = new Crossword(10, 10);
    widget.c!.reset();



    return FutureBuilder(
        future: _read(context, "data/data2.json")
            .then(parseWords),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;

            print(" Cruciverba : \n " + widget.c.toString());

            var row = MyDrawerHelper.getRowsInSquare(context, width, widget.c!);

            // row.add(Positioned(
            //     top: height / 2,
            //     left: width / 2,
            //     child: ElevatedButton(
            //       child: Text("BTN"),
            //       onPressed: () {},
            //     )));

            return Scaffold(
              body: SingleChildScrollView(
                  child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            children: row,
                          ),

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
        });
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

    data.shuffle();

    data.forEach((record) {
      String parola = record["name"].toString().toLowerCase();

      if (!widget.c!.isCompleted() /*i++ < 9000*/) {
        if (widget.c!.addWord(parola) == 0) {
          // orrizzontale
        } else if (widget.c!.addWord(parola) == 1) {
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

List jsonWords = [
  {"name": "one"},
  {"name": "name"},
  {"name": "same"},
  {"name": "space"},
  {"name": "hand"},
  {"name": "water"},
  {"name": "peace"},
  {"name": "clean"},
  {"name": "chair"},
  {"name": "word"},
];
