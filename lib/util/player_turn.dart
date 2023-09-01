import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:turn_game/main.dart';
import 'package:turn_game/spritesheet/spritesheet_builder.dart';
import 'package:turn_game/util/turn_manager.dart';

abstract class PlayerTurn extends SimpleNpc
    with
        TapGesture,
        MoveToPositionAlongThePath,
        BlockMovementCollision,
        Attackable,
        UseBarLife {
  late TurnManager turnManager;
  late Rect rectYoutGridPosition;
  final Paint rectPaint = Paint()..color = Colors.blue.withOpacity(0.5);
  final Paint _rectPaintClick = Paint()..color = Colors.white.withOpacity(0.5);
  final Paint gridPaint = Paint()
    ..color = Colors.white.withOpacity(0.5)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  final Paint gridAttackPaint = Paint()..color = Colors.red.withOpacity(0.5);
  Vector2 countTileRadiusMove = Vector2.all(1);
  Vector2 countTileRadiusAttack = Vector2.all(1);
  final List<Rect> _gridCanMove = [];
  final List<Rect> _gridCanAttack = [];
  bool isSelected = false;
  Rect? rectClick;

  ShapeHitbox? hitbox;

  void doAttackChar(PlayerTurn char);

  PlayerTurn({
    required super.position,
    required super.size,
    required super.animation,
  }) {
    rectYoutGridPosition = Rect.fromLTWH(x, y, tileSize.x, tileSize.y);
    setupMoveToPositionAlongThePath(
      pathLineColor: Colors.transparent,
    );

    setupBarLife(
      position: Vector2(0, -(tileSize.y / 3)),
      borderWidth: 2,
      size: Vector2(size.x * 2, 6),
      borderRadius: BorderRadius.circular(1),
    );
  }

  @override
  Future<void> onLoad() {
    add(
      hitbox = RectangleHitbox(
        size: Vector2(size.x - 1, size.y - 1),
        position: Vector2.all(1),
      ),
    );
    return super.onLoad();
  }

  @override
  void onTap() {
    if (isSelected) {
      turnManager.selectCharacter(null);
      gameRef.bonfireCamera.stop();
    } else {
      bool changed = turnManager.selectCharacter(this);
      if (changed) {
        gameRef.bonfireCamera.moveToTargetAnimated(
          target: this,
          effectController: EffectController(duration: 1),
        );
      }
    }
    _calculateAttackAndMoveGrid();
  }

  @override
  bool handlerPointerDown(PointerDownEvent event) {
    if (isSelected) {
      final worldPosition = gameRef.screenToWorld(event.position.toVector2());
      _checkIfMove(worldPosition);
      _checkIfAttack(worldPosition);
      _getRectClick(worldPosition);
    }
    return super.handlerPointerDown(event);
  }

  @override
  bool handlerPointerUp(PointerUpEvent event) {
    rectClick = null;
    return super.handlerPointerUp(event);
  }

  @override
  void render(Canvas canvas) {
    if (isSelected) {
      canvas.save();
      canvas.translate(-x, -y);
      if (!isMovingAlongThePath) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rectYoutGridPosition,
            const Radius.circular(4),
          ),
          rectPaint,
        );
      }
      _renderMoveGrid(canvas);
      _renderAttackGrid(canvas);
      if (rectClick != null) {
        canvas.drawRect(
          rectClick!,
          _rectPaintClick,
        );
      }
      canvas.restore();
    }
    super.render(canvas);
  }

  @override
  void update(double dt) {
    isSelected = turnManager.isYourTurn(this);
    double xGrid = absoluteCenter.x ~/ tileSize.x * tileSize.x;
    double yGrid = absoluteCenter.y ~/ tileSize.y * tileSize.y;
    rectYoutGridPosition = Rect.fromLTWH(xGrid, yGrid, size.x, size.y);
    super.update(dt);
  }

  @override
  void onMount() {
    turnManager = BonfireInjector.instance.get();
    super.onMount();
  }

  void _calculateGridCanMove() {
    _gridCanMove.clear();
    double xGrid = rectYoutGridPosition.left;
    double yGrid = rectYoutGridPosition.top;

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
          var rect = Rect.fromLTWH(
            startXGrid + indexX * width,
            startYGrid + indexY * height,
            width,
            height,
          );
          bool containCollision = gameRef.collisions().where((element) {
            return element.toRect().overlaps(rect);
          }).isNotEmpty;
          if (!containCollision) {
            _gridCanMove.add(rect);
          }
        },
      );
    });
  }

  void _calculateGridCanAttack() {
    _gridCanAttack.clear();
    double xGrid = rectYoutGridPosition.left;
    double yGrid = rectYoutGridPosition.top;

    double deslocamentoX = countTileRadiusAttack.x * tileSize.x;
    double deslocamentoY = countTileRadiusAttack.y * tileSize.y;

    double startXGrid = xGrid - deslocamentoX;
    double startYGrid = yGrid - deslocamentoY;

    int sizeX = countTileRadiusAttack.x.toInt() * 2 + 1;
    int sizeY = countTileRadiusAttack.y.toInt() * 2 + 1;

    List.generate(sizeY, (indexY) {
      List.generate(
        sizeX,
        (indexX) {
          _gridCanAttack.add(
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

  void _checkIfAttack(Vector2 worldPosition) {
    final findAttack = _gridCanAttack.where((element) {
      return element.contains(worldPosition.toOffset());
    });

    if (findAttack.isNotEmpty) {
      final players = gameRef.query<PlayerTurn>().where((element) {
        return element.rectCollision.overlaps(findAttack.first.deflate(2));
      });

      for (var p in players) {
        if (p != this) {
          doAttackChar(p);
        }
      }
    }
  }

  void _checkIfMove(Vector2 worldPosition) {
    final find = _gridCanMove.where((element) {
      return element.contains(worldPosition.toOffset());
    });

    if (find.isNotEmpty) {
      final collisions = gameRef.collisions().where((element) {
        return element != hitbox &&
            element.toRect().overlaps(find.first.deflate(2));
      });

      if (!collisions.isNotEmpty) {
        moveToPositionAlongThePath(
          worldPosition,
          onFinish: () {
            _calculateAttackAndMoveGrid();
            turnManager.doAction();
          },
        );
      }
    }
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, identify) {
    if (isDead) {
      return;
    }
    showDamage(damage, config: TextStyle(fontSize: tileSize.x / 2));
    var lastDirection = lastDirectionHorizontal;
    if (lastDirection == Direction.left) {
      animation?.playOnce(
        animation!.others[SpriteSheetBuilder.ANIMATION_HITED_LEFT]!,
      );
    } else {
      animation?.playOnce(
        animation!.others[SpriteSheetBuilder.ANIMATION_HITED_RIGHT]!,
      );
    }

    super.receiveDamage(attacker, damage, identify);
  }

  @override
  void die() {
    var lastDirection = lastDirectionHorizontal;
    if (lastDirection == Direction.left) {
      animation?.playOnce(
        animation!.others[SpriteSheetBuilder.ANIMATION_DIE_LEFT]!,
        runToTheEnd: true,
        onFinish: removeFromParent,
      );
    } else {
      animation?.playOnce(
        animation!.others[SpriteSheetBuilder.ANIMATION_DIE_RIGHT]!,
        onFinish: removeFromParent,
        runToTheEnd: true,
      );
    }

    super.die();
  }

  void _calculateAttackAndMoveGrid() {
    _calculateGridCanMove();
    _calculateGridCanAttack();
  }

  void _renderMoveGrid(Canvas canvas) {
    for (var element in _gridCanMove) {
      canvas.drawRect(element, gridPaint);
    }
  }

  void _renderAttackGrid(Canvas canvas) {
    for (var element in _gridCanAttack) {
      canvas.drawCircle(
        element.center,
        tileSize.x / 4.5,
        gridAttackPaint,
      );
    }
  }

  void _getRectClick(Vector2 worldPosition) {
    double xGrid = worldPosition.x ~/ tileSize.x * tileSize.x;
    double yGrid = worldPosition.y ~/ tileSize.y * tileSize.y;
    rectClick = Rect.fromLTWH(xGrid, yGrid, tileSize.x, tileSize.y);
  }
}
