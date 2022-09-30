import 'package:bonfire/bonfire.dart';
import 'package:turn_game/main.dart';
import 'package:turn_game/spritesheet/spritesheet_builder.dart';
import 'package:turn_game/util/player_ally.dart';
import 'package:turn_game/util/player_enemy.dart';

class PHero extends PlayerAlly {
  PHero({required super.position})
      : super(
          size: tileSize,
          animation: SpriteSheetBuilder.build(
            SpriteSheetBuilder.SPRITE_HERO,
          ),
        );

  @override
  void doAttackEnemy(PlayerEnemy enemy) {
    enemy.receiveDamage(AttackFromEnum.PLAYER_OR_ALLY, 10, 0);
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      turnManager.chageTurn();
    });
  }
}
