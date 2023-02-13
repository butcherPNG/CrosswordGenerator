
import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crosswordgen/pages/crosswordPage.dart';
import 'package:crosswordgen/pages/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCrosswordPage extends StatefulWidget {

  @override
  _CreateCrosswordPageState createState() => _CreateCrosswordPageState();
}

class _CreateCrosswordPageState extends State<CreateCrosswordPage> {

  List<TextField> txtFields = [];
  List<TextEditingController> controllers = [];
  late Stream<List<TextField>> listStream;
  bool isEmptyField = true;
  int controllerIndex = 0;
  TextEditingController title = TextEditingController();

  InputDecoration inputDecoration = InputDecoration(
    hintText: 'Введите слово${r"\"}описание',
    border: OutlineInputBorder()
  );

  TextField addTextField({
    required TextEditingController controller,
    required InputDecoration decoration,
  }){
    return TextField(
      controller: controller,
      decoration: decoration,
    );
  }
  Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
  createCrossword() async {

    String id = title.text;

    List<Map<String, dynamic>> data = [];
    for(int i = 0; i < txtFields.length; i++){
      if (controllers[i].text.trim().isNotEmpty){
          List<String> parts = controllers[i].text.split(r"\");
          data.add({
            'name': parts[0],
            'description': parts[1]
          });

      }

    }
    print(data);
    String jsonString = jsonEncode(data);
    print(jsonString);
    setString(title.text, jsonString);


    AutoRouter.of(context).pushNamed('/crossword/$id');


  }

  @override
  void initState() {
    controllers.add(TextEditingController());
    txtFields.add(addTextField(controller: controllers[controllerIndex], decoration: inputDecoration));
    listStream = Stream.fromIterable([txtFields]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title:
          TextField(
              controller: title,
              decoration: InputDecoration(
                  hintText: 'Введите название кроссворда',
                  border: OutlineInputBorder()
              )
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: (){
                setState(() {
                  controllers.add(TextEditingController());
                  controllerIndex++;
                  txtFields.add(addTextField(controller: controllers[controllerIndex], decoration: inputDecoration));
                });
              },
              child: const Icon(Icons.add),
            ),
            SizedBox(height: 10,),
            FloatingActionButton(
              onPressed: (){
                createCrossword();

              },
              child: const Icon(Icons.save),
            ),
          ],
        ),
        body: StreamBuilder<List<TextField>>(
          stream: listStream,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return ListView.builder(
                      itemCount: txtFields.length,
                      itemBuilder: (context, index){
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: SizedBox(
                                width: 500,
                                child: txtFields[index]
                            ),
                          ),
                        );
                    }
                );
            }
            return CircularProgressIndicator();
          },
        )

    );
  }






}