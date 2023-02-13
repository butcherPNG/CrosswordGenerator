
import 'package:auto_route/annotations.dart';
import 'package:crosswordgen/pages/create_crossword_page.dart';
import 'package:crosswordgen/pages/crosswordPage.dart';
import 'package:crosswordgen/pages/main_page.dart';


@MaterialAutoRouter(routes: [
  AutoRoute(page: MainPage, initial: true),
  AutoRoute(page: CreateCrosswordPage, path: '/create-crossword'),
  AutoRoute(page: CrosswordPage, path: '/crossword/:id')

],
replaceInRouteName: 'Page,Route'
)

class $AppRouter{}