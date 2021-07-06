import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'example.dart';
import 'game/core.dart';

void main() {
  ///Change Example with actual Game
  Game game = Game(ExampleGameEngine(), ExampleGameView('Timer'));
  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final Game game;
  MyApp(this.game);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.gameEngine,
      child: MaterialApp(
        title: game.gameView.title,
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
        home: game.gameView,
      )
    );
  }
}