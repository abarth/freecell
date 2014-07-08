// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.deck;

class Rank {
  static get all => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

  final int value;

  Rank(this.value) {
    assert(all.contains(value));
  }
}
