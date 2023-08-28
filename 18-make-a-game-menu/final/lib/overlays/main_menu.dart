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

import 'package:flutter/material.dart';

import '../meteormania_game.dart';

class MainMenu extends StatelessWidget {
  static const String overlayName = 'MainMenu';

  // Reference to parent game.
  final MeteormaniaGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 250,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.15),
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Meteormania',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    game.overlays.remove(overlayName);
                    game.initializeGame();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(width: 3.0, color: Colors.white),
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
