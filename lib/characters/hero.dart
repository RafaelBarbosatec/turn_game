import 'package:turn_game/main.dart';
import 'package:turn_game/spritesheet/spritesheet_builder.dart';
import 'package:turn_game/util/game_ally.dart';
import 'package:turn_game/util/game_enemy.dart';

class PHero extends GameAlly {
  PHero({required super.position})
      : super(
          size: tileSize,
          animation: SpriteSheetBuilder.build(
            SpriteSheetBuilder.SPRITE_HERO,
          ),
        );

  @override
  void doAttackEnemy(GameEnemy enemy) {
    // TODO: implement doAttackEnemy
  }
}
