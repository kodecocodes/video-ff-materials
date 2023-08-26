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

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../game_constants.dart';
import '../utils/load_sprite.dart';

enum MeteoriteSize { small, big }

class Meteorite extends SpriteComponent {
  static final Sprite smallSprite = loadMeteormaniaSprite(688, 287, 64, 64);
  static final Vector2 smallSize = Vector2(64, 64);
  static final Sprite bigSprite = loadMeteormaniaSprite(592, 288, 96, 96);
  static final Vector2 bigSize = Vector2(96, 96);

  final MeteoriteSize meteoriteSize;

  bool get isBig => meteoriteSize == MeteoriteSize.big;

  double directionAngle;
  final Vector2 velocity = Vector2.zero();

  Meteorite.small({required this.directionAngle})
      : meteoriteSize = MeteoriteSize.small,
        super(
          sprite: smallSprite,
          size: smallSize,
        );

  Meteorite.big({required this.directionAngle})
      : meteoriteSize = MeteoriteSize.big,
        super(
          sprite: bigSprite,
          size: bigSize,
        );

  @override
  FutureOr<void> onLoad() {
    add(RotateEffect.by(
      isBig ? pi : 2 * pi,
      EffectController(
        duration: isBig ? 20 : 10,
        infinite: true,
      ),
    ));

    add(
      MoveEffect.by(
        Vector2(cos(directionAngle), sin(directionAngle)),
        EffectController(
          duration: 1,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    velocity.x = GameConstants.meteoriteSpeed * cos(directionAngle);
    velocity.y = GameConstants.meteoriteSpeed * sin(directionAngle);
    position += velocity * dt;
    if (position.x < -bigSize.toSize().width) {
      position.x = GameConstants.cameraWidth + bigSize.toSize().width;
    }
    if (position.x > GameConstants.cameraWidth + bigSize.toSize().width) {
      position.x = -bigSize.toSize().width;
    }
    if (position.y < -bigSize.toSize().height) {
      position.y = GameConstants.cameraHeight + bigSize.toSize().height;
    }
    if (position.y > GameConstants.cameraHeight + bigSize.toSize().height) {
      position.y = -bigSize.toSize().height;
    }

    super.update(dt);
  }
}
