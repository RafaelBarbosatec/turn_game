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
    simpleAttackRangeByAngle(
      animation: SpriteSheetBuilder.fireballRight,
      size: size,
      angle: BonfireUtil.angleBetweenPoints(center, ally.center),
      damage: 20,
      attackFrom: AttackFromEnum.ENEMY,
      onDestroy: turnManager.doAction,
      marginFromOrigin: tileSize.x,
    );
  }
}
