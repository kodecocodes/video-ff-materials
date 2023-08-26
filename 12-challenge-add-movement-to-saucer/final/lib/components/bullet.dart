import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../game_constants.dart';

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
///

class Bullet extends PositionComponent {
  static const double bulletWidth = 12;
  static const double bulletHeight = 4;
  static final Vector2 bulletSize = Vector2(bulletWidth, bulletHeight);
  static const bulletRect = Rect.fromLTWH(
    0,
    0,
    bulletWidth,
    bulletHeight,
  );

  final Vector2 velocity = Vector2.zero();
  double directionAngle;

  final _bulletPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFFFFFFFF);

  Bullet({
    required this.directionAngle,
    super.position,
  }) : super(size: Bullet.bulletSize);

  @override
  FutureOr<void> onLoad() {
    angle = directionAngle;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Bullet.bulletRect, _bulletPaint);
    final dirVect = Vector2(cos(directionAngle), sin(directionAngle));

    add(
      MoveEffect.by(
        dirVect,
        EffectController(
          duration: 1,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    velocity.x = GameConstants.bulletSpeed * cos(directionAngle);
    velocity.y = GameConstants.bulletSpeed * sin(directionAngle);
    position += velocity * dt;
    if (position.x > GameConstants.cameraWidth || position.x < 0) {
      removeFromParent();
    }
    if (position.y > GameConstants.cameraHeight || position.y < 0) {
      removeFromParent();
    }

    super.update(dt);
  }
}
