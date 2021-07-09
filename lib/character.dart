import 'package:demoduck/element.dart';
import 'package:demoduck/skill.dart';
import 'package:demoduck/weapon.dart';

class Character{
  late String name;
  late String element;
  late int hp;
  late int sp;
  late int _maxHp;
  late int _maxSp;
  late int _atk;
  late int _multiplier;
  late Skill _skill;

  Character(this.name, this.element, this.hp, this.sp) {
    this._maxHp = hp;
    this._maxSp = sp;
    this._multiplier=Element().getMultiplier(element);
    _skill=new Skill("harden"/**TODO skill*/);
    _atk = Weapon().getWpnDmg(name)*Element().getBuff(element);
  }

  String getName() => name;
  String getElement() => element;
  Skill getSkill() => _skill;
  int getHp() => hp;
  int getSp() => sp;
  int getMaxHp() => _maxHp;
  int getMaxSp() => _maxSp;
  int getAtk() => _atk;
  int getMultiplier() => _multiplier;

  void setHp(int hp){
    if(hp < 0){
      this.hp = 0;
    } else {
      this.hp = hp;
    }
  }
  void setSp(int sp){
    this.sp=sp;
  }
  void reset(){
    this.sp=_maxSp;
    this.hp=_maxHp;
  }

  num passiveSkill(num dmg, Character opponent) {
    if(_skill.type=="passive atk"){
      dmg = _skill.getPassive(dmg, _skill);
    }
    if (opponent._skill.type=="harden") {
      dmg = opponent._skill.getPassive(dmg, opponent._skill);
    }
    return dmg;
  }
}