import 'duel.dart';
import 'models/armor.dart';
import 'models/gladiator.dart';
import 'models/weapon.dart';

main(){

  var rustySword = Weapon(
    damage: 25,
    critChance: 15,
    stunchance: 10,
    decapitateChance: 0

  );

  var lessRustySword = Weapon(
    damage: 30,
    critChance: 15,
    stunchance: 5,
    decapitateChance: 1
  );

  var armor = Armor(
    protection: 0.5,
    breakChance: 20
  );

  final player1 = Gladiator(
    name: 'Player 1',
    health: 100,
    dodgeChance: 10,
    parryChance: 5,
    weapon: rustySword,
    armor: armor,
    speed: 5
    );

  final player2 = Gladiator(
    name: 'Player 2',
    health: 100,
    dodgeChance: 10,
    parryChance: 5,
    weapon: rustySword,
    armor: armor,
    speed: 5
  );

  
  var maxRounds = 0;
  var p1Wins = 0;
  var p2Wins = 0;
  var numDecapitations = 0;

  var iterations = 1000000;
  var testMode = true;

  Duel duel;

  for(int i=0; i<iterations;i++){

    duel = Duel(player1: player1, player2: player2);

    duel.testMode = testMode;

    if(duel.begin() == 1){
      p1Wins++;


      if(duel.player2Local.isDecapitated){
        numDecapitations++;

      }
    }else{

      p2Wins++;

      if(duel.player1Local.isDecapitated){
        numDecapitations++;
      }

    }

    if(duel.numRounds > maxRounds){
      maxRounds = duel.numRounds;
    }

  }

  print('Max rounds: $maxRounds');
  print('Player 1 wins: $p1Wins');
  print('Player 2 wins: $p2Wins');
  print('Decaps: $numDecapitations');

}