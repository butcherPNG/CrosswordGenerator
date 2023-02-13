// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../create_crossword_page.dart' as _i2;
import '../crosswordPage.dart' as _i3;
import '../main_page.dart' as _i1;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.MainPage(),
      );
    },
    CreateCrosswordRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i2.CreateCrosswordPage(),
      );
    },
    CrosswordRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CrosswordRouteArgs>(
          orElse: () => CrosswordRouteArgs(id: pathParams.getString('id')));
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.CrosswordPage(id: args.id),
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          MainRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          CreateCrosswordRoute.name,
          path: '/create-crossword',
        ),
        _i4.RouteConfig(
          CrosswordRoute.name,
          path: '/crossword/:id',
        ),
      ];
}

/// generated route for
/// [_i1.MainPage]
class MainRoute extends _i4.PageRouteInfo<void> {
  const MainRoute()
      : super(
          MainRoute.name,
          path: '/',
        );

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.CreateCrosswordPage]
class CreateCrosswordRoute extends _i4.PageRouteInfo<void> {
  const CreateCrosswordRoute()
      : super(
          CreateCrosswordRoute.name,
          path: '/create-crossword',
        );

  static const String name = 'CreateCrosswordRoute';
}

/// generated route for
/// [_i3.CrosswordPage]
class CrosswordRoute extends _i4.PageRouteInfo<CrosswordRouteArgs> {
  CrosswordRoute({required String id})
      : super(
          CrosswordRoute.name,
          path: '/crossword/:id',
          args: CrosswordRouteArgs(id: id),
          rawPathParams: {'id': id},
        );

  static const String name = 'CrosswordRoute';
}

class CrosswordRouteArgs {
  const CrosswordRouteArgs({required this.id});

  final String id;

  @override
  String toString() {
    return 'CrosswordRouteArgs{id: $id}';
  }
}
