// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.deck;

class Rank {
  static get all => [
    new Rank(1),
    new Rank(2),
    new Rank(3),
    new Rank(4),
    new Rank(5),
    new Rank(6),
    new Rank(7),
    new Rank(8),
    new Rank(9),
    new Rank(10),
    new Rank(11),
    new Rank(12),
    new Rank(13),
  ];

  final int value;

  bool operator==(other) {
    return value == other.value;
  }

  String get serialization {
    switch (value) {
      case 13:
        return "K";
      case 12:
        return "Q";
      case 11:
        return "J";
      case 10:
        return "T";
      case 1:
        return "A";
    }
    return value.toString();
  }

  Rank(this.value) {
    assert(value > 0);
    assert(value <= 13);
  }
}
