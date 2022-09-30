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
    // TODO: implement doAttackEnemy
  }
}
