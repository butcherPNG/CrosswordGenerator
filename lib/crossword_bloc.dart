

import 'package:crosswordgen/helpers/DrawerHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BorderState {
  final int widgetId;
  final Border border;

  BorderState(this.widgetId, this.border);
}

class CrosswordBloc extends Bloc<CrosswordEvent, Map<int, Border>>{
  CrosswordBloc() : super (Map.fromIterable(List.generate(15 * 15, (i) => i), value: (_) => Border.all(color: Colors.black))) {
    on<CrosswordCheckEvent>(_onCrosswordCheck);
  }

  _onCrosswordCheck(CrosswordCheckEvent event, Emitter<Map<int, Border>> emit){
    Map<int, Border> widgetBorders = Map();
    for (int i = 0; i < row.length; i++){
      Square widget = row[i];
      String txt = widget.txt;
      int widgetId = widget.id;
      TextEditingController? controller = widget.controller;
      if (controller!.text.toLowerCase().trim() == txt.toLowerCase().trim()){

        widgetBorders[widgetId] = Border.all(color: Colors.green, width: 2);

      }else{
        widgetBorders[widgetId] = Border.all(color: Colors.red, width: 2);
      }
      emit(widgetBorders);

    }
  }
}


abstract class CrosswordEvent{}
class CrosswordCheckEvent extends CrosswordEvent{}