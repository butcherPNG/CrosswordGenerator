
import 'package:auto_route/auto_route.dart';
import 'package:crosswordgen/pages/create_crossword_page.dart';
import 'package:crosswordgen/pages/crosswordPage.dart';
import 'package:crosswordgen/pages/main_page.dart';
import 'package:crosswordgen/pages/routes/app_router.gr.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   late AppRouter appRouter;
  @override
  void initState() {
    appRouter = AppRouter();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return MaterialApp.router(
      title: 'Crossword Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),


    );
  }
}



