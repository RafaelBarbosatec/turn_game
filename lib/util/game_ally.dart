import 'package:turn_game/util/character_turn.dart';
import 'package:turn_game/util/game_enemy.dart';

abstract class GameAlly extends CharacterTurn {
  GameAlly({
    required super.position,
    required super.size,
    required super.animation,
  });

  @override
  void doAttackChar(CharacterTurn char) {
    if (char is GameEnemy) {
      doAttackEnemy(char);
    }
  }

  void doAttackEnemy(GameEnemy enemy);
}
