import 'dart:math';

import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:bonfire/bonfire.dart';
import 'package:turn_game/util/player_ally.dart';
import 'package:turn_game/util/player_enemy.dart';

enum OwnerTurn { ally, enemy }

class TurnManager extends GameComponent {
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
      _selectOneEnemy();
    } else {
      _selectOneAlly();
    }
  }

  bool isYourTurn(GameComponent char) => char == characterSelected;

  void startGame() async {
    await Future.delayed(const Duration(milliseconds: 500));
    bool startAlly = Random().nextBool();
    if (startAlly) {
      _selectOneAlly();
    } else {
      _selectOneEnemy();
    }
  }

  void _selectOneAlly() {
    ownerTurn = OwnerTurn.ally;
    final ally = game?.componentsByType<PlayerAlly>() ?? [];
    if (ally.isNotEmpty) {
      ally.first.onTap();
      game?.camera.target = ally.first;
    }
  }

  void _selectOneEnemy() {
    ownerTurn = OwnerTurn.enemy;
    final enemy = game?.componentsByType<PlayerEnemy>() ?? [];
    if (enemy.isNotEmpty) {
      enemy.first.onTap();
      game?.camera.target = enemy.first;
    }
  }

  @override
  void onMount() {
    startGame();
    super.onMount();
  }
}
