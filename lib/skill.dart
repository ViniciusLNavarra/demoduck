class Skill{
  String _type;
  Skill(this._type);
  String get type => _type;
  num getPassive(num dmg, Skill skill) {
    if (skill._type == "harden"){
      dmg = dmg - 2;
    }
    return dmg;
  }

  num getActive(num dmg, Skill skill) {
    if (skill._type == "slash"){
      dmg = dmg + 2;
    }
    return dmg;
  }
}