import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:bonfire/bonfire.dart';
import 'package:turn_game/util/player_ally.dart';
import 'package:turn_game/util/player_enemy.dart';

enum OwnerTurn { ally, enemy }

class TurnManager {
  BonfireGameInterface? game;
  OwnerTurn ownerTurn = OwnerTurn.ally;
  GameComponent? characterSelected;

  bool selectCharacter(GameComponent? char) {
    if (ownerTurn == OwnerTurn.ally) {
      if (char is PlayerAlly) {
        characterSelected = char;
        return true;
      }
    }
    if (ownerTurn == OwnerTurn.enemy) {
      if (char is PlayerEnemy) {
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
      final enemy = game?.componentsByType<PlayerEnemy>() ?? [];
      if (enemy.isNotEmpty) {
        enemy.first.onTap();
        game?.camera.moveToTargetAnimated(enemy.first);
      }
    } else {
      ownerTurn = OwnerTurn.ally;
      final ally = game?.componentsByType<PlayerAlly>() ?? [];
      if (ally.isNotEmpty) {
        ally.first.onTap();
        game?.camera.moveToTargetAnimated(ally.first);
      }
    }
  }

  bool isYourTurn(GameComponent char) => char == characterSelected;
}
