import 'package:bonfire/bonfire.dart';
import 'package:turn_game/main.dart';
import 'package:turn_game/spritesheet/spritesheet_builder.dart';
import 'package:turn_game/util/player_ally.dart';
import 'package:turn_game/util/player_enemy.dart';

class Ghost extends PlayerEnemy {
  @override
  // ignore: overridden_fields
  Vector2 countTileRadiusMove = Vector2.all(2);

  Ghost({required super.position})
      : super(
          size: tileSize,
          animation: SpriteSheetBuilder.build(
            SpriteSheetBuilder.SPRITE_GHOST,
          ),
        ) {
    initialLife(150);
  }

  @override
  void doAttackAlly(PlayerAlly ally) {
    ally.receiveDamage(AttackFromEnum.ENEMY, 25,0);
    simpleAttackMeleeByAngle(
      animation: SpriteSheetBuilder.attackRight,
      size: size,
      angle: BonfireUtil.angleBetweenPoints(center, ally.center),
      damage: 0,
      attackFrom: AttackFromEnum.ENEMY,
      withPush: false,
    );
    Future.delayed(const Duration(milliseconds: 300))
        .then((value) => turnManager.doAction());
  }
}
