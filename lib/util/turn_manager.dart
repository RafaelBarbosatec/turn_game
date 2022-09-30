import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:turn_game/util/player_ally.dart';
import 'package:turn_game/util/player_enemy.dart';

enum OwnerTurn { ally, enemy }

class TurnManager extends GameComponent with ChangeNotifier {
  OwnerTurn ownerTurn = OwnerTurn.ally;
  GameComponent? characterSelected;
  PlayerAlly? _lastAlly;
  PlayerEnemy? _lastEnemy;
  bool endGame = false;

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
    notifyListeners();
  }

  bool isYourTurn(GameComponent char) => char == characterSelected;

  void _selectOneAlly() {
    ownerTurn = OwnerTurn.ally;
    if (_lastAlly == null || _lastAlly?.isDead == true) {
      final ally = gameRef
          .componentsByType<PlayerAlly>()
          .where((element) => !element.isDead);
      if (ally.isNotEmpty) {
        _lastAlly = ally.first;
      }
    }
    _lastAlly?.onTap();
    gameRef.camera.target = _lastAlly;
  }

  void _selectOneEnemy() {
    ownerTurn = OwnerTurn.enemy;
    if (_lastEnemy == null || _lastEnemy?.isDead == true) {
      final enemy = gameRef
          .componentsByType<PlayerEnemy>()
          .where((element) => !element.isDead);
      if (enemy.isNotEmpty) {
        _lastEnemy = enemy.first;
      }
    }
    _lastEnemy?.onTap();
    gameRef.camera.target = _lastEnemy;
  }

  @override
  void onMount() {
    startGame();
    super.onMount();
  }

  void startGame() async {
    endGame = false;
    await Future.delayed(const Duration(milliseconds: 500));
    bool startAlly = Random().nextBool();
    if (startAlly) {
      _selectOneAlly();
    } else {
      _selectOneEnemy();
    }
  }

  @override
  void update(double dt) {
    if (checkInterval('GAME_OVER', 1000, dt) && !endGame) {
      var enemyLife = gameRef
          .componentsByType<PlayerEnemy>()
          .where((element) => !element.isDead);
      if (enemyLife.isEmpty) {
        endGame = true;
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Ally win'),
            );
          },
        );
      }

      var allyLife = gameRef
          .componentsByType<PlayerAlly>()
          .where((element) => !element.isDead);
      if (allyLife.isEmpty) {
        endGame = true;
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Enemy win'),
            );
          },
        );
      }
    }
    super.update(dt);
  }
}
