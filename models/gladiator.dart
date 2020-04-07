import 'armor.dart';
import 'weapon.dart';

class Gladiator {
  final String name;
  final int health;
  final int dodgeChance;
  final Weapon weapon;
  final Armor armor;
  final int parryChance;
  final int speed;

  Gladiator({this.speed, 
      this.name,
      this.health,
      this.dodgeChance,
      this.weapon,
      this.armor,
      this.parryChance});
}