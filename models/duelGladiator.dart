import 'armor.dart';
import 'gladiator.dart';
import 'weapon.dart';

class DuelGladiator implements Gladiator {
  Armor armor;
  int dodgeChance;
  int health;
  String name;
  int parryChance;
  Weapon weapon;
  int speed;

  //contains variables and methods used only in a duel
  bool armorIsBroke;
  bool isStunned;
  bool isDecapitated;

  DuelGladiator(
      {this.name,
      this.armor,
      this.health,
      this.weapon,
      this.armorIsBroke = false,
      this.dodgeChance,
      this.isStunned = false,
      this.parryChance,
      this.speed,
      this.isDecapitated = false});
}
