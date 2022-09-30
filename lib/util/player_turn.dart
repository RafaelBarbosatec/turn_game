import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:turn_game/main.dart';
import 'package:turn_game/turn_manager.dart';

abstract class PlayerTurn extends SimpleNpc
    with TapGesture, MoveToPositionAlongThePath, ObjectCollision {
  late TurnManager turnManager;
  late Rect rectYoutGridPosition;
  final Paint rectPaint = Paint()..color = Colors.blue.withOpacity(0.5);
  final Paint gridPaint = Paint()
    ..color = Colors.white.withOpacity(0.5)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  Vector2 countTileRadiusMove = Vector2.all(1);
  final List<Rect> _gridCanMove = [];
  bool isSelected = false;
  PlayerTurn({
    required super.position,
    required super.size,
    required super.animation,
  }) {
    rectYoutGridPosition = Rect.fromLTWH(x, y, tileSize.x, tileSize.y);
    setupMoveToPositionAlongThePath(
      pathLineColor: Colors.transparent,
    );
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(size.x - 1, size.y - 1),
            align: Vector2.all(1),
          ),
        ],
      ),
    );
  }

  @override
  void onTap() {
    if (isSelected) {
      turnManager.selectCharacter(null);
      gameRef.camera.target = null;
    } else {
      bool changed = turnManager.selectCharacter(this);
      if (changed) {
        gameRef.camera.moveToTargetAnimated(this);
      }
    }
    _calculateGridCanMove();
  }

  @override
  bool handlerPointerDown(PointerDownEvent event) {
    if (isSelected) {
      final worldPosition = gameRef.screenToWorld(event.position.toVector2());

      final find = _gridCanMove.where((element) {
        return element.contains(worldPosition.toOffset());
      });

      if (find.isNotEmpty) {
        final collisions = gameRef.collisions().where((element) {
          return element.rectConsideringCollision
              .overlaps(find.first.deflate(2));
        });

        for (var collision in collisions) {
          if (collision is PlayerTurn) {
            _verifyIfInRangeAttack(collision);
          }
        }

        if (collisions.isNotEmpty) {
          return super.handlerPointerDown(event);
        }

        moveToPositionAlongThePath(
          gameRef.screenToWorld(event.position.toVector2()),
          onFinish: turnManager.chageTurn,
        );
      }
    }
    return super.handlerPointerDown(event);
  }

  @override
  void render(Canvas canvas) {
    if (isSelected) {
      if (!isMovingAlongThePath) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rectYoutGridPosition,
            const Radius.circular(4),
          ),
          rectPaint,
        );
      }
      for (var element in _gridCanMove) {
        canvas.drawRect(element, gridPaint);
      }
    }

    super.render(canvas);
  }

  @override
  void update(double dt) {
    isSelected = turnManager.isYourTurn(this);
    double xGrid = center.x ~/ tileSize.x * tileSize.x;
    double yGrid = center.y ~/ tileSize.y * tileSize.y;
    rectYoutGridPosition = Rect.fromLTWH(xGrid, yGrid, size.x, size.y);
    super.update(dt);
  }

  @override
  void onMount() {
    turnManager = BonfireInjector.instance.get();
    turnManager.game = gameRef;
    super.onMount();
  }

  void _calculateGridCanMove() {
    _gridCanMove.clear();
    double xGrid = center.x ~/ tileSize.x * tileSize.x;
    double yGrid = center.y ~/ tileSize.y * tileSize.y;

    double deslocamentoX = countTileRadiusMove.x * tileSize.x;
    double deslocamentoY = countTileRadiusMove.y * tileSize.y;

    double startXGrid = xGrid - deslocamentoX;
    double startYGrid = yGrid - deslocamentoY;

    int sizeX = countTileRadiusMove.x.toInt() * 2 + 1;
    int sizeY = countTileRadiusMove.y.toInt() * 2 + 1;

    List.generate(sizeY, (indexY) {
      List.generate(
        sizeX,
        (indexX) {
          _gridCanMove.add(
            Rect.fromLTWH(
              startXGrid + indexX * width,
              startYGrid + indexY * height,
              width,
              height,
            ),
          );
        },
      );
    });
  }

  void _verifyIfInRangeAttack(PlayerTurn char) {
    if (char == this) {
      return;
    }

    /// Implementar aqui area de ataque.
    doAttackChar(char);
  }

  void doAttackChar(PlayerTurn char);
}
