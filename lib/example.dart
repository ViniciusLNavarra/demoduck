import 'package:demoduck/game/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

///Creates a Timer
///Keep as foundation on how it works

class ExampleGameEngine extends GameEngine{

  @override
  void stateChange(GameState old, GameState changed) {
    // nothing to do
  }

  @override
  void updatePhysics(int tickCounter) {
    notifyListeners();
  }
}

class ExampleGameView extends GameView{
  ExampleGameView(String title) : super(title);

  @override
  Widget getEndPage(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () => {engine.gameState = GameState.running},
              child: Text('Replay')
          ),
          ElevatedButton(
              onPressed: () => {engine.gameState = GameState.start},
              child: Text('Back to Start')
          )
        ]
      )
    );
  }

  @override
  Widget getRunPage(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(2.5),
            child: Text(
              'Elapsed time: ${NumberFormat("###.#", "en_US").format(engine.tickCount/500)}',
              textScaleFactor: 2
            )
          ),
          ElevatedButton(
              onPressed: () => {engine.gameState = GameState.end},
              child: Text('End')
          )
        ]
      )
    );
  }

  @override
  Widget getStartPage(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return Center(
      child: ElevatedButton(
        onPressed: () => {engine.gameState = GameState.running},
        child: Text('Start')
      )
    );
  }
}