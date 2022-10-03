import 'package:bonfire/bonfire.dart';
import 'package:turn_game/main.dart';
import 'package:turn_game/spritesheet/spritesheet_builder.dart';
import 'package:turn_game/util/player_ally.dart';
import 'package:turn_game/util/player_enemy.dart';

class Knight extends PlayerAlly {
  @override
  // ignore: overridden_fields
  Vector2 countTileRadiusMove = Vector2.all(2);

  Knight({required super.position})
      : super(
          size: tileSize,
          animation: SpriteSheetBuilder.build(
            SpriteSheetBuilder.SPRITE_KNIGHT,
          ),
        ) {
    initialLife(150);
  }

  @override
  void doAttackEnemy(PlayerEnemy enemy) {
    enemy.receiveDamage(AttackFromEnum.PLAYER_OR_ALLY, 25, 0);
    simpleAttackMeleeByAngle(
      animation: SpriteSheetBuilder.attackRight,
      size: size,
      angle: BonfireUtil.angleBetweenPoints(center, enemy.center),
      damage: 25,
      attackFrom: AttackFromEnum.PLAYER_OR_ALLY,
      withPush: false,
    );
    Future.delayed(const Duration(milliseconds: 300))
        .then((value) => turnManager.doAction());
  }
}
