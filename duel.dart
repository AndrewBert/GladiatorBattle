import 'dart:io';
import 'dart:math';

import 'models/duelGladiator.dart';
import 'models/gladiator.dart';

class Duel {
  Gladiator player1;
  Gladiator player2;

  DuelGladiator player1Local;
  DuelGladiator player2Local;

  int numRounds = 0;
  bool testMode = false;

  Duel({this.player1, this.player2});

  int begin() {
    attack(DuelGladiator attacker, DuelGladiator defender) {
      var critOccured = false;
      var hitOccured = false;
      var dodgeOccured = false;
      var parryOccured = false;
      int parryDamage = 0;
      int damageDealt = 0;
      var armorBrokeThisTurn = false;

      hit() {
        hitOccured = true;

        bool crit() {
          var rng = Random().nextInt(100);
          return rng < attacker.weapon.critChance ? true : false;
        }

        var armor = defender.armor;

        armorProtection() {
          damageDealt = (damageDealt * armor.protection).round();
        }

        bool doesArmorBreak() {
          var rng = Random().nextInt(100);
          armor = defender.armor;

          if (rng < armor.breakChance) {
            defender.armorIsBroke = true;
            return true;
          } else {
            return false;
          }
        }

        bool stun() {
          var rng = Random().nextInt(100);
          if (rng < attacker.weapon.stunchance) {
            return true;
          }
          return false;
        }

        bool decapitate() {
          var rng = Random().nextInt(1000);
          return rng < attacker.weapon.decapitateChance ? true : false;
        }

        if (stun()) {
          defender.isStunned = true;
          
          if (decapitate()) {
            defender.isDecapitated = true;
            defender.health = 0;
          } 
        }
        
        if (!defender.isDecapitated) {
          damageDealt = attacker.weapon.damage;

          if (crit()) {
            critOccured = true;
            damageDealt *= 2;
          }

          if (!defender.armorIsBroke) {
            armorProtection();
          }

          if (!defender.isDecapitated) {
            damageDealt = damageDealt.round();
            defender.health -= damageDealt;
          }

          if (!defender.armorIsBroke) {
            if (doesArmorBreak()) {
              armorBrokeThisTurn = true;
            }
          }
        }
      }

      bool dodge() {
        var rng = Random().nextInt(100);
        return rng < defender.dodgeChance ? true : false;
      }

      bool parry() {
        var rng = Random().nextInt(100);
        if (rng < defender.parryChance) {
          parryDamage = (defender.weapon.damage / 4).round();

          attacker.health -= parryDamage;
          return true;
        }

        return false;
      }

      if (!attacker.isStunned) {
        if (dodge()) {
          dodgeOccured = true;
        } else if (parry()) {
          parryOccured = true;
        } else {
          hit();
        }
      }

      //print statements
      if (!testMode) {
        if (!attacker.isStunned) {
          print('${attacker.name} is attacking ${defender.name}.');
          if (hitOccured) {
            if (defender.isDecapitated) {
              print('${defender.name} was decapitated by ${attacker.name}!');
            } else {
              if (critOccured) {
                print(
                    '${attacker.name} SLAPPED ${damageDealt} damage at ${defender.name}!');
              } else {
                print(
                    '${attacker.name} dealt ${damageDealt} damage to ${defender.name}!');
              }

              if (armorBrokeThisTurn) {
                print('${defender.name}s armor broke!');
              }

              if (defender.isStunned) {
                print('${defender.name} was stunned!');
              }
            }
          } else if (dodgeOccured) {
            print('${defender.name} dodged the attack!\n');
          } else if (parryOccured) {
            print(
                "${defender.name} parried the attack and dealt $parryDamage to ${attacker.name}!");
            print(
                "${attacker.name} has ${attacker.health} health remaining!\n");
          }
        } else {
          print('${attacker.name} cannot attack because he is stunned.\n');
        }
        print("${defender.name} has ${defender.health} health remaining!\n");
      }

      attacker.isStunned = false;
    }

    var playerDead = false;

    player1Local = DuelGladiator(
        name: player1.name,
        health: player1.health,
        dodgeChance: player1.dodgeChance,
        parryChance: player1.parryChance,
        weapon: player1.weapon,
        armor: player1.armor,
        speed: player1.speed);

    player2Local = DuelGladiator(
        name: player2.name,
        health: player2.health,
        dodgeChance: player2.dodgeChance,
        parryChance: player2.parryChance,
        weapon: player2.weapon,
        armor: player2.armor,
        speed: player2.speed);

    DuelGladiator attacker;
    DuelGladiator defender;

    var speedOdds = player1Local.speed + player2Local.speed;

    //decides who goes first, higher speed = better chance of going first
    if (Random().nextInt(speedOdds) < player1Local.speed) {
      attacker = player1Local;
      defender = player2Local;
    } else {
      attacker = player2Local;
      defender = player1Local;
    }

    var newRound = true;
    var turnCount = 1;

    while (!playerDead) {
      if (newRound) {
        numRounds++;
        if (!testMode) {
          print('**Round $numRounds**\n');
        }
        newRound = false;
        turnCount = 1;
      }

      if (turnCount == 2) {
        newRound = true;
      } else {
        turnCount++;
      }

      attack(attacker, defender);

      if (defender.health > 0 && attacker.health > 0) {
        if (!testMode) {
          print('###############Press any button to continue###############');
          stdin.readLineSync();
        }

        var temp = attacker;
        attacker = defender;
        defender = temp;
      } else {
        playerDead = true;
        if (!testMode) {
          print('#####Game over!#######################\n\n');
        }
      }
    }
    if (player2Local.health <= 0) {
      return 1;
    } else {
      return 2;
    }
  }
}
