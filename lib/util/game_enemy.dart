import 'package:flutter/material.dart';
import 'package:turn_game/util/character_turn.dart';
import 'package:turn_game/util/game_ally.dart';

abstract class GameEnemy extends CharacterTurn {
  @override
  // ignore: overridden_fields
  final Paint rectPaint = Paint()..color = Colors.red.withOpacity(0.5);

  GameEnemy({
    required super.position,
    required super.size,
    required super.animation,
  });

  @override
  void doAttackChar(CharacterTurn char) {
    if (char is GameAlly) {
      doAttackAlly(char);
    }
  }

  void doAttackAlly(GameAlly ally);
}
