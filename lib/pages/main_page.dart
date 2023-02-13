
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crosswordgen/pages/crosswordPage.dart';
import 'package:crosswordgen/pages/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {



  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<String> crosswords = [];
  List<String> values = [];
  List<String> keys = [];
  getCrosswords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     keys = prefs.getKeys().toList();

    for (String key in keys) {
      String? value = prefs.getString(key);
      if (value != null) {
        values.add(value);
      }
    }
  }

  @override
  void initState() {
    getCrosswords();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            AutoRouter.of(context).pushNamed('/create-crossword');
          },
          child: Icon(Icons.add),
        ),
        body: keys.isEmpty ? Center(
            child: Text('No crosswords')
        ) : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5

            ),
            itemCount: keys.length,
            itemBuilder: (context, index){
              return Center(
                child: ElevatedButton(
                  onPressed: (){
                    AutoRouter.of(context).pushNamed('/crossword/${keys[index]}');

                  },
                  child: Text('Open a crossword ${keys[index]}'),
                ),
              );
            }
        )

    );
  }






}