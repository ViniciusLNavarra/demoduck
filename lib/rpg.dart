import 'dart:async';
import 'dart:math';

import 'package:demoduck/game/core.dart';
import 'package:demoduck/character.dart';
import 'package:demoduck/combat.dart';
import 'package:demoduck/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RpgGameEngine extends GameEngine{

  @override
  void stateChange(GameState old, GameState changed) {
    // nothing to do
  }

  @override
  void updatePhysics(int tickCounter) {
    notifyListeners();
  }
}

class RpgGameView extends GameView{
  //TODO immutable error
  double _y = 0;
  final Combat combat = new Combat();
  late Character player;
  late Character enemy;
  String endTxt = "";

  RpgGameView(String title) : super(title){
    enemy = combat.enemy;
    player = combat.player;
  }

  Color getBtnColor(Set<MaterialState> states){
    const Set<MaterialState> active = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused
    };
    if (states.any(active.contains)){
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Text getTxt(Txt value){
    if (TextVal[value] == null || TextVal[value] == ""){
      return Text("Error: No value");
    } else {
      return Text(TextVal[value].toString());
    }
  }

  String getWinner(){
    if(player.hp==0){
      return "You lost";
    } else{
      if (enemy.hp==0){
        return "You win";
      } else {
        return endTxt;
      }
    }
  }

  @override
  Widget getEndPage(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(getWinner()),
          ElevatedButton(
              onPressed: () => {
                player.reset(),
                enemy.reset(),
                engine.gameState = GameState.running
              },
              child: getTxt(Txt.replay)
          ),
          ElevatedButton(
              onPressed: () => {engine.gameState = GameState.start},
              child: getTxt(Txt.back)
          )
        ]
      )
    );
  }

  @override
  Widget getRunPage(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    ///Relative Positions of View Objects
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double duckImgWidth = _width/3;
    double duckHeight = _height/3;
    double duckLeft = _width/7;
    double buttonHeight = _height/8-10;
    double buttonWidth = (_width-20)/2-10;

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          top: 0,
          child: Container(
            color: Colors.blue,
            height: _height/5,
            width: _width
          )
        ),
        Positioned(
          top: _height/5,
          child: Container(
              color: Colors.green,
              height: _height*4/5,
              width: _width
          )
        ),
        Positioned(
          top: duckHeight/2,
          left: duckLeft*6,
          child: Transform.translate(
            offset: Offset(0, _y),
            child: Transform(
              transform: Matrix4.rotationY(pi),
              child: Image(
                width: duckImgWidth,
                image: AssetImage('assets/normal.png'),
              )
            )
          )
        ),
        FloatingActionButton(onPressed: () => {
          _y += 20,
          Timer(Duration(milliseconds: 200), () => {_y=0})
        }),
        Positioned(
          top: duckHeight,
          left: duckLeft,
          child: Transform.translate(
            offset: Offset(0, _y),
            child: Image(
              width: duckImgWidth,
              image: AssetImage('assets/normal.png')
            ),
          )
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: _height/16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                height: _height/4,
                width: _width-20,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        height: buttonHeight,
                        width: buttonWidth,
                        child: SizedBox.expand(
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.resolveWith(getBtnColor),
                              overlayColor: MaterialStateProperty.resolveWith((states) => Color.fromRGBO(255, 255, 255, 0.2))
                            ),
                            onPressed: () => {
                              combat.turn(player, enemy, Txt.attack),
                              if(player.hp==0||enemy.hp==0){
                                engine.gameState=GameState.end
                              }
                            },
                            child: getTxt(Txt.attack)
                          )
                        )
                      )
                    ),
                    Positioned(
                      left: (_width-20)/2,
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        height: buttonHeight,
                        width: buttonWidth,
                        child: SizedBox.expand(
                          child: TextButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.resolveWith(getBtnColor),
                                overlayColor: MaterialStateProperty.resolveWith((states) => Color.fromRGBO(255, 255, 255, 0.2))
                            ),
                            onPressed: () => {
                              combat.turn(player, enemy, Txt.skill),
                              if(player.hp==0||enemy.hp==0){
                                engine.gameState=GameState.end
                              }
                            },
                            child: getTxt(Txt.skill)
                          )
                        )
                      )
                    ),
                    Positioned(
                      top: _height/8,
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        height: buttonHeight,
                        width: buttonWidth,
                        child: SizedBox.expand(
                          child: TextButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.resolveWith(getBtnColor),
                                overlayColor: MaterialStateProperty.resolveWith((states) => Color.fromRGBO(255, 255, 255, 0.2))
                            ),
                            onPressed: () => {
                              if(combat.capture()){
                                endTxt="Enemy captured",
                                engine.gameState=GameState.end
                              }
                            },
                            child: getTxt(Txt.capture)
                          )
                        )
                      )
                    ),
                    Positioned(
                      top: _height/8,
                      left: (_width-20)/2,
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        height: buttonHeight,
                        width: buttonWidth,
                        child: SizedBox.expand(
                          child: TextButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.resolveWith(getBtnColor),
                                overlayColor: MaterialStateProperty.resolveWith((states) => Color.fromRGBO(255, 255, 255, 0.2))
                            ),
                            onPressed: () =>
                            {
                              if(combat.escape()){
                                endTxt="You ran away",
                                engine.gameState = GameState.end}
                            },
                            child: getTxt(Txt.escape)
                          )
                        )
                      )
                    )
                  ],
                )
              )
            )
          ]
        )
      ]
    );
  }

  @override
  Widget getStartPage(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return Center(
      child: ElevatedButton(
        onPressed: () => {
          player.reset(),
          enemy.reset(),
          engine.gameState = GameState.running
        },
        child: getTxt(Txt.start)
      )
    );
  }
}