import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'rpg.dart';
import 'game/core.dart';

void main() {
  ///Change Example with actual Game
  ///Game game = Game(ExampleGameEngine(), ExampleGameView('Timer'));
  Game game = Game(RpgGameEngine(), RpgGameView('Duckdemo'));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(0, 0, 0, 0.5),
      systemNavigationBarColor: Colors.transparent
    )
  );
  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final Game game;
  MyApp(this.game);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.gameEngine,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: game.gameView.title,
        theme: ThemeData(
          fontFamily: 'Press Start 2P',
          primarySwatch: Colors.blue,
        ),
        home: game.gameView,
      )
    );
  }
}