import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class Game {
  final GameView gameView;
  final GameEngine gameEngine;

  Game(this.gameEngine, this.gameView);
}

abstract class GameView extends StatelessWidget{
  Widget getStartPage(BuildContext context);
  Widget getRunPage(BuildContext context);
  Widget getEndPage(BuildContext context);

  final String title;

  GameView(this.title);
  Widget _getGamePages(BuildContext context, GameEngine game) {
    switch (game.gameState) {
      case GameState.start:
        return getStartPage(context);
      case GameState.running:
        return getRunPage(context);
      case GameState.end:
        return getEndPage(context);
    }
  }

  @override
  Widget build(BuildContext context){
    GameEngine game = Provider.of<GameEngine>(context);
    return Scaffold(
      body: SafeArea(
          child: _getGamePages(context, game)
      )
    );
  }
}

enum GameState{
  start, running, end
}

abstract class GameEngine extends ChangeNotifier{
  Timer? _timer;
  int _tickCounter;
  GameState _gameState;
  GameEngine() : _gameState = GameState.start, _tickCounter = 0;

  void stateChange(GameState old, GameState changed);
  void updatePhysics(int tickCounter);

  GameState get gameState => _gameState;
  int get tickCount => _tickCounter;

  set gameState(GameState newState){
    if (_gameState == newState) return;
    stateChange(_gameState, newState);
    _gameState = newState;
    if (_gameState == GameState.running) {
      _startGame();
    } else{
      _stopGame();
    }
    updateView();
  }

  void _startGame(){
    _stopGame();
    _tickCounter = 0;
    _timer = new Timer.periodic(Duration(milliseconds: 20), _processTick);
  }

  void _stopGame(){
    _timer?.cancel();
  }

  void updateView(){
    notifyListeners();
  }

  void _processTick(Timer unused){
    ++_tickCounter;
    updatePhysics(_tickCounter);
  }
}