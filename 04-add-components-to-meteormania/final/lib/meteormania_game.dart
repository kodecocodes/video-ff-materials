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
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/meteorite.dart';
import 'components/spaceship.dart';
import 'game_constants.dart';

class MeteormaniaGame extends FlameGame {
  late World _world;
  late CameraComponent _cameraComponent;

  @override
  Color backgroundColor() => const Color(0xff0b0018);

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

  void initializeGame() {
    final spaceship = Spaceship()
      ..anchor = Anchor.center
      ..position = Vector2(
        GameConstants.cameraWidth / 2,
        GameConstants.cameraHeight / 2,
      );

    _world.add(spaceship);

    final smallMeteorite = Meteorite.small();

    _world.add(smallMeteorite);
  }
}
