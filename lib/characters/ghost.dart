import 'package:turn_game/main.dart';
import 'package:turn_game/spritesheet/spritesheet_builder.dart';
import 'package:turn_game/util/game_ally.dart';
import 'package:turn_game/util/game_enemy.dart';

class Ghost extends GameEnemy {
  Ghost({required super.position})
      : super(
          size: tileSize,
          animation: SpriteSheetBuilder.build(
            SpriteSheetBuilder.SPRITE_GHOST,
          ),
        );

  @override
  void doAttackAlly(GameAlly ally) {
    print(ally);
  }
}
