import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:bonfire/bonfire.dart';
import 'package:turn_game/util/game_ally.dart';
import 'package:turn_game/util/game_enemy.dart';

enum OwnerTurn { ally, enemy }

class TurnManager {
  BonfireGameInterface? game;
  OwnerTurn ownerTurn = OwnerTurn.ally;
  GameComponent? characterSelected;

  bool selectCharacter(GameComponent? char) {
    if (ownerTurn == OwnerTurn.ally) {
      if (char is GameAlly) {
        characterSelected = char;
        return true;
      }
    }
    if (ownerTurn == OwnerTurn.enemy) {
      if (char is GameEnemy) {
        characterSelected = char;
        return true;
      }
    }
    if (char == null) {
      characterSelected = null;
    }
    return false;
  }

  void chageTurn() {
    if (ownerTurn == OwnerTurn.ally) {
      ownerTurn = OwnerTurn.enemy;
      final enemy = game?.componentsByType<GameEnemy>() ?? [];
      if (enemy.isNotEmpty) {
        enemy.first.onTap();
        game?.camera.moveToTargetAnimated(enemy.first);
      }
    } else {
      ownerTurn = OwnerTurn.ally;
      final ally = game?.componentsByType<GameAlly>() ?? [];
      if (ally.isNotEmpty) {
        ally.first.onTap();
        game?.camera.moveToTargetAnimated(ally.first);
      }
    }
  }

  bool isYourTurn(GameComponent char) => char == characterSelected;
}
