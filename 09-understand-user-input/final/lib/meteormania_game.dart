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
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/meteorite.dart';
import 'components/saucer.dart';
import 'components/spaceship.dart';
import 'game_constants.dart';
import 'manager/game_manager.dart';
import 'utils/random_position.dart';

class MeteormaniaGame extends FlameGame with TapCallbacks, DragCallbacks {
  late World _world;
  late CameraComponent _cameraComponent;

  GameManager manager = GameManager();

  @override
  Color backgroundColor() => const Color(0xff0b0018);

  @override
  bool get debugMode => true;

  @override
  FutureOr<void> onLoad() async {
    await Flame.images.load('bg1.png');
    await Flame.images.load('meteormania_spritesheet.png');

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

    initializeGame();
  }

  @override
  void onTapUp(TapUpEvent event) {
    print('Tap!');
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    print('Drag! ${event.delta}');
  }

  void initializeGame() {
    final spaceship = Spaceship()
      ..anchor = Anchor.center
      ..position = Vector2(
        GameConstants.cameraWidth / 2,
        GameConstants.cameraHeight / 2,
      );

    _world.add(spaceship);

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
}
