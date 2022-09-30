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
        );

  @override
  void doAttackEnemy(PlayerEnemy enemy) {
    print(enemy);
  }
}
