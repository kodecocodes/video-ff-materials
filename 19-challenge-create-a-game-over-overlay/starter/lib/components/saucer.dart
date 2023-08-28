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

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../game_constants.dart';
import '../meteormania_game.dart';
import '../utils/load_sprite.dart';
import 'bullet.dart';

class Saucer extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MeteormaniaGame> {
  static const double saucerWidth = 128.0;
  static const double saucerHeight = 64.0;
  static final Sprite saucerSprite = loadMeteormaniaSprite(0, 0, 128, 64);
  static final Vector2 saucerSize = Vector2(saucerWidth, saucerHeight);

  Saucer() : super(sprite: saucerSprite, size: saucerSize);

  final Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());

    add(
      MoveEffect.by(
        Vector2(Random().nextBool() ? 1 : -1, 0),
        EffectController(
          duration: 1,
          infinite: true,
        ),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    velocity.x = GameConstants.saucerSpeed;
    position += velocity * dt;
    if (position.x + saucerWidth / 2 < 0 ||
        position.x - saucerWidth / 2 > GameConstants.cameraWidth) {
      removeFromParent();
    }

    if (game.manager.isGameOver) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
