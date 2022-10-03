import 'package:bonfire/bonfire.dart';
import 'package:turn_game/main.dart';
import 'package:turn_game/spritesheet/spritesheet_builder.dart';
import 'package:turn_game/util/player_ally.dart';
import 'package:turn_game/util/player_enemy.dart';

class Necromancer extends PlayerEnemy {
  @override
  // ignore: overridden_fields
  Vector2 countTileRadiusAttack = Vector2.all(3);
  Necromancer({required super.position})
      : super(
          size: tileSize,
          animation: SpriteSheetBuilder.build(
            SpriteSheetBuilder.SPRITE_NECROMANCER,
          ),
        );

  @override
  void doAttackAlly(PlayerAlly ally) {
    ally.receiveDamage(AttackFromEnum.ENEMY, 15, 0);
    Future.delayed(const Duration(milliseconds: 300))
        .then((value) => turnManager.doAction());
  }
}
