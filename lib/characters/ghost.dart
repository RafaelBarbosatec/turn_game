import 'package:turn_game/main.dart';
import 'package:turn_game/spritesheet/spritesheet_builder.dart';
import 'package:turn_game/util/player_ally.dart';
import 'package:turn_game/util/player_enemy.dart';

class Ghost extends PlayerEnemy {
  Ghost({required super.position})
      : super(
          size: tileSize,
          animation: SpriteSheetBuilder.build(
            SpriteSheetBuilder.SPRITE_GHOST,
          ),
        );

  @override
  void doAttackAlly(PlayerAlly ally) {
    print(ally);
  }
}
