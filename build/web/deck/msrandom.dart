// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.deck;

class MSRandom implements Random {
  int _seed;

  MSRandom(this._seed);

  int _rand() {
    _seed = (_seed * 214013 + 2531011) & 0x7FFFFFFF;
    return ((_seed >> 16) & 0x7fff);
  }

  int nextInt(max) {
    return _rand() % max;
  }

  double nextDouble() {
    return _rand() % 100 / 100.0;
  }

  bool nextBool() {
    return nextDouble() < 0.5;
  }
}
