import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:turn_game/characters/ghost.dart';
import 'package:turn_game/characters/hero.dart';
import 'package:turn_game/characters/knight.dart';
import 'package:turn_game/characters/necromancer.dart';
import 'package:turn_game/turn_manager.dart';

class TurnGame extends StatelessWidget {
  const TurnGame({super.key});

  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      joystick: JoystickMoveToPosition(
        enabledMoveCameraWithClick: true,
        mouseButtonUsedToMoveCamera: MouseButton.right,
      ),
      map: WorldMapByTiled(
        'map/map1.tmj',
        objectsBuilder: {
          'hero': ((p) => PHero(position: p.position)),
          'ghost': ((p) => Ghost(position: p.position)),
          'knight': ((p) => Knight(position: p.position)),
          'necro': ((p) => Necromancer(position: p.position)),
        },
      ),
      cameraConfig: CameraConfig(zoom: 2, moveOnlyMapArea: true),
      components: [
        BonfireInjector.instance.get<TurnManager>(),
      ],
    );
  }
}
