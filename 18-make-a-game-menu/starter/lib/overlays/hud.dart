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

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game_constants.dart';
import '../meteormania_game.dart';

class Hud extends PositionComponent with HasGameRef<MeteormaniaGame> {
  static const hudTextStyle = TextStyle(
    fontFamily: 'PressStart2P',
    color: Color.fromRGBO(255, 255, 255, 1),
  );

  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _levelComponent;
  late TextComponent _healthComponent;
  late TextComponent _pointsComponent;

  @override
  Future<void>? onLoad() async {
    _levelComponent = TextComponent(
      text: 'LVL ${game.manager.level}',
      textRenderer: TextPaint(
        style: hudTextStyle.copyWith(
          fontSize: 18,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(
        GameConstants.cameraWidth / 2,
        GameConstants.cameraHeight - 32,
      ),
    );

    _healthComponent = TextComponent(
      text: 'Lives: ${game.manager.health}',
      textRenderer: TextPaint(
        style: hudTextStyle.copyWith(
          fontSize: 14,
        ),
      ),
      anchor: Anchor.centerLeft,
      position: Vector2(32, 32),
    );

    _pointsComponent = TextComponent(
      text: 'Points: ${game.manager.points}',
      textRenderer: TextPaint(
        style: hudTextStyle.copyWith(
          fontSize: 14,
        ),
      ),
      anchor: Anchor.centerLeft,
      position: Vector2(32, 64),
    );

    addAll([
      _levelComponent,
      _healthComponent,
      _pointsComponent,
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _levelComponent.text = 'LVL ${game.manager.level}';
    _healthComponent.text = 'Lives: ${game.manager.health}';
    _pointsComponent.text = 'Points: ${game.manager.points}';

    if (game.manager.isGameOver) {
      removeFromParent();
    }

    super.update(dt);
  }
}
