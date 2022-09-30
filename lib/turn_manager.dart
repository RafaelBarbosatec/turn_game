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
  PlayerAlly? _lastAlly;
  PlayerEnemy? _lastEnemy;

  bool selectCharacter(GameComponent? char) {
    if (ownerTurn == OwnerTurn.ally) {
      if (char is PlayerAlly) {
        characterSelected = char;
        _lastAlly = char;
        return true;
      }
    }
    if (ownerTurn == OwnerTurn.enemy) {
      if (char is PlayerEnemy) {
        characterSelected = char;
        _lastEnemy = char;
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

  void _selectOneAlly() {
    ownerTurn = OwnerTurn.ally;
    if (_lastAlly == null || _lastAlly?.isDead == true) {
      final ally = game?.componentsByType<PlayerAlly>() ?? [];
      if (ally.isNotEmpty) {
        _lastAlly = ally.first;
      }
    }
    _lastAlly?.onTap();
    game?.camera.target = _lastAlly;
  }

  void _selectOneEnemy() {
    ownerTurn = OwnerTurn.enemy;
    if (_lastEnemy == null || _lastEnemy?.isDead == true) {
      final enemy = game?.componentsByType<PlayerEnemy>() ?? [];
      if (enemy.isNotEmpty) {
        _lastEnemy = enemy.first;
      }
    }
    _lastEnemy?.onTap();
    game?.camera.target = _lastEnemy;
  }

  @override
  void onMount() {
    startGame();
    super.onMount();
  }

  void startGame() async {
    await Future.delayed(const Duration(milliseconds: 500));
    bool startAlly = Random().nextBool();
    if (startAlly) {
      _selectOneAlly();
    } else {
      _selectOneEnemy();
    }
  }
}
