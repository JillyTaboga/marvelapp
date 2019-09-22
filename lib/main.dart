import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:marvelheroes/blocs/series_bloc.dart';
import 'package:marvelheroes/inicialscreen.dart';

import 'blocs/main_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: MaterialApp(
          title: "RollPlay",
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            accentColor: Color.fromARGB(255, 255, 0, 19),
          ),
          home: InicialScreen(),
        ),
      blocs: [
        Bloc((i) => MainBloc()),
        Bloc((i) => SeriesBloc()),
      ],
    );
  }
}