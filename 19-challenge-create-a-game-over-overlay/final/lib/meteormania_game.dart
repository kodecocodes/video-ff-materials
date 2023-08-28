/// Copyright (c) 2023 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to
/// deal in the Software without restriction, including without limitation the
/// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
/// sell copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge,
/// publish, distribute, sublicense, create a derivative work, and/or sell
/// copies of the Software in any work that is designed, intended, or marketed
/// for pedagogical or instructional purposes related to programming, coding,
/// application development, or information technology.  Permission for such
/// use, copying, modification, merger, publication, distribution, sublicensing,
///  creation of derivative works, or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import 'components/background.dart';
import 'components/bullet.dart';
import 'components/meteorite.dart';
import 'components/saucer.dart';
import 'components/spaceship.dart';
import 'game_constants.dart';
import 'manager/game_manager.dart';
import 'overlays/game_over.dart';
import 'overlays/hud.dart';
import 'utils/random_position.dart';

class MeteormaniaGame extends FlameGame
    with TapCallbacks, DragCallbacks, HasCollisionDetection {
  late World _world;
  late CameraComponent _cameraComponent;
  Spaceship? _spaceship;

  GameManager manager = GameManager();
  bool _isShooting = false;
  bool _hitByEnemy = false;

  @override
  Color backgroundColor() => const Color(0xff0b0018);

  @override
  bool get debugMode => true;

  @override
  FutureOr<void> onLoad() async {
    await Flame.images.load('bg1.png');
    await Flame.images.load('meteormania_spritesheet.png');

    await FlameAudio.audioCache.loadAll([
      'sfx/explosion.mp3',
      'sfx/laser.mp3',
      'sfx/destroy_meteorite.mp3',
    ]);
    await FlameAudio.bgm.play('music/background_music.mp3', volume: 0.3);

    final background = Background();

    _world = World()..add(background);

    add(_world);

    _cameraComponent = CameraComponent(world: _world)
      ..viewfinder.visibleGameSize =
          Vector2(GameConstants.cameraWidth, GameConstants.cameraHeight)
      ..viewfinder.position =
          Vector2(GameConstants.cameraWidth / 2, GameConstants.cameraHeight / 2)
      ..viewfinder.anchor = Anchor.center;

    add(_cameraComponent);
  }

  @override
  void onTapUp(TapUpEvent event) {
    FlameAudio.play('sfx/laser.mp3');
    shootBullet();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _spaceship?.lookAt(event.canvasPosition);
  }

  void initializeGame() {
    _spaceship = Spaceship()
      ..anchor = Anchor.center
      ..position = Vector2(
        GameConstants.cameraWidth / 2,
        GameConstants.cameraHeight / 2,
      );

    _world.add(_spaceship!);

    _world.add(Hud());

    addEnemies();
  }

  void addEnemies() {
    final (saucerX, saucerY) = randomPosition(
      Saucer.saucerWidth * GameConstants.saucerMaxMovementFactor,
      Saucer.saucerHeight * GameConstants.saucerMaxMovementFactor,
      Spaceship.spaceshipSize.toSize(),
    );
    final saucer = Saucer()
      ..anchor = Anchor.center
      ..position = Vector2(saucerX, saucerY);

    final meteorites = List.generate(manager.level, (i) {
      final isBigMeteorite = Random().nextBool();
      final randomAngle = 2 * pi * Random().nextDouble();

      if (isBigMeteorite) {
        final spriteSize = Meteorite.bigSize.toSize();
        final (meteoriteX, meteoriteY) = randomPosition(
          spriteSize.width,
          spriteSize.height,
          Spaceship.spaceshipSize.toSize(),
        );
        return Meteorite.big(
          directionAngle: randomAngle,
        )
          ..anchor = Anchor.center
          ..position = Vector2(meteoriteX, meteoriteY);
      }

      final spriteSize = Meteorite.smallSize.toSize();
      final (meteoriteX, meteoriteY) = randomPosition(
        spriteSize.width,
        spriteSize.height,
        Spaceship.spaceshipSize.toSize(),
      );
      return Meteorite.small(
        directionAngle: randomAngle,
      )
        ..anchor = Anchor.center
        ..position = Vector2(meteoriteX, meteoriteY);
    });

    _world
      ..add(saucer)
      ..addAll(meteorites);
  }

  void shootBullet() {
    if (!_isShooting && !manager.isGameOver) {
      _isShooting = true;
      _world.add(
        Bullet(directionAngle: _spaceship!.angle + 3 * pi / 2)
          ..anchor = Anchor.center
          ..position = _spaceship!.position,
      );
      _isShooting = false;
    }
  }

  void spaceshipHit(bool isBigMeteorite) {
    FlameAudio.play('sfx/explosion.mp3');
    if (!_hitByEnemy) {
      _hitByEnemy = true;
      manager.playerHit();
    }

    if (isBigMeteorite) {
      manager.bigMeteoriteDestroyed();
    } else {
      manager.smallMeteoriteDestroyed();
    }

    _spaceship?.add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 5,
        ),
      )..onComplete = () {
          _hitByEnemy = false;
        },
    );

    if (manager.isGameOver) {
      overlays.add(GameOver.overlayName);
    }

    if (manager.isLevelOver) {
      nextLevel();
    }
  }

  void bonusEnemyHit() {
    FlameAudio.play('sfx/explosion.mp3');
    manager.addPoints(5);

    if (manager.isLevelOver) {
      nextLevel();
    }
  }

  void splitMeteorite(Vector2 position) {
    final meteorites = List.generate(manager.meteoriteFragments, (i) {
      final directionAngle = 2 * pi * Random().nextDouble();
      return Meteorite.small(
        directionAngle: directionAngle,
      )
        ..anchor = Anchor.center
        ..size = Meteorite.smallSize
        ..position = position;
    });

    _world.addAll(meteorites);
  }

  void meteoriteHit(bool isBigMeteorite) {
    FlameAudio.play('sfx/destroy_meteorite.mp3');
    if (isBigMeteorite) {
      manager.addPoints(2);
      manager.bigMeteoriteDestroyed();
    } else {
      manager.addPoints(1);
      manager.smallMeteoriteDestroyed();
    }

    if (manager.isLevelOver) {
      nextLevel();
    }
  }

  void nextLevel() {
    manager.newWave();
    addEnemies();
  }

  void reset() {
    manager.reset();

    initializeGame();
  }
}
