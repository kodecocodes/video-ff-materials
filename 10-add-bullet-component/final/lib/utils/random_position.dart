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

import 'dart:math';
import 'dart:ui';

import '../game_constants.dart';

double randomX(double componentWidth, double restrictedWidth) {
  final randomXPos = Random().nextDouble() * GameConstants.cameraWidth;

  if (randomXPos > (GameConstants.cameraWidth / 2) - restrictedWidth &&
      randomXPos < (GameConstants.cameraWidth / 2) + restrictedWidth) {
    return randomX(componentWidth, restrictedWidth);
  }

  if (randomXPos - componentWidth / 2 < 0 ||
      randomXPos + componentWidth / 2 > GameConstants.cameraWidth) {
    return randomX(componentWidth, restrictedWidth);
  }

  return randomXPos;
}

double randomY(double componentHeight, double restrictedHeight) {
  final randomYPos = Random().nextDouble() * GameConstants.cameraHeight;

  if (randomYPos > (GameConstants.cameraHeight / 2) - restrictedHeight &&
      randomYPos < (GameConstants.cameraHeight / 2) + restrictedHeight) {
    return randomY(componentHeight, restrictedHeight);
  }

  if (randomYPos - componentHeight / 2 < 0 ||
      randomYPos + componentHeight / 2 > GameConstants.cameraHeight) {
    return randomY(componentHeight, restrictedHeight);
  }

  return randomYPos;
}

(double x, double y) randomPosition(
  double componentWidth,
  double componentHeight,
  Size restrictedArea,
) {
  return (
    randomX(componentWidth, restrictedArea.width),
    randomY(componentHeight, restrictedArea.height),
  );
}
