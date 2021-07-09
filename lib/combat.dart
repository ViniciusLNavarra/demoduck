import 'dart:math';

import 'package:demoduck/character.dart';
import 'package:demoduck/enums.dart';


class Combat {
  late Character player;
  late Character enemy;
  
  Combat(){
    player=Character("Duck", "Aeteher", 20, 10);
    enemy=Character("Enemy", "Fire", 10, 10);
  }

  bool escape(){
    double probability;
    double transition = 0.2/(-0.65);
    num equation = pow(1-(enemy.hp/player.hp),7)+pow(player.hp/enemy.hp,7);
    if(transition<=equation) {
      probability = 0.65*pow(1-enemy.hp / player.hp, 7)+0.1;
    } else {
      probability = 0.65*pow(player.hp / enemy.hp, 7)+0.1;
    }
    if (probability< Random().nextDouble()){
      enemyTurn();
      return false;
    } else {
      enemyTurn();
      return true;
    }
  }

  bool capture() {
    double probability;
    double transition = 0.2/(-0.65);
    num equation = pow(1-(enemy.hp/player.hp),7)+pow(player.hp/enemy.hp,7);
    if(transition>equation) {
      probability = 0.65*pow(1-enemy.hp / player.hp, 7)+0.1;
    } else {
      probability = 0.65*pow(player.hp / enemy.hp, 7)+0.1;
    }
    if (probability< Random().nextDouble()){
      enemyTurn();
      return false;
    } else {
      enemyTurn();
      return true;
    }
  }

  void skill(Character attacker, Character opponent) {
    if (attacker.getSkill().type == 'harden'){
      print('is passive');
    } else{
      print(skill);
    }
  }

  void attack(Character attacker, Character opponent) {
    num dmg = attacker.getAtk()*attacker.getMultiplier();
    print(dmg);
    dmg = attacker.passiveSkill(dmg, opponent);
    print(dmg);
    opponent.setHp(opponent.hp-dmg.toInt());
  }

  void turn(Character actor, Character opponent, Txt action){
    switch(action){
      case Txt.attack:
        attack(actor, opponent);
        break;
      case Txt.skill:
        skill(actor, opponent);
        break;
      default:
        print("Invalid Turn");
    }
    if (actor.name == player.name && action != Txt.escape){
      print('${actor.name} => ${action} => ${opponent.name}');
      print('${actor.name}: ${actor.hp}\n${opponent.name}: ${opponent.hp}');
      enemyTurn();
    } else {
      print('${actor.name} => ${action} => ${opponent.name}');
      print('${actor.name}: ${actor.hp}\n${opponent.name}: ${opponent.hp}');
    }
  }

  void enemyTurn(){
    switch(Random().nextInt(2)){
      case 0:
        turn(enemy, player, Txt.attack);
        break;
      case 1:
        turn(enemy, player, Txt.skill);
        break;
    }
  }
}