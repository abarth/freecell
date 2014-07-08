// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.deck;

class Suit {
  static const Suit CLUBS = const Suit._("\u2663");
  static const Suit DIAMONDS = const Suit._("\u2666");
  static const Suit HEARTS = const Suit._("\u2665");
  static const Suit SPADES = const Suit._("\u2660");

  static get all => [CLUBS, DIAMONDS, HEARTS, SPADES];

  Color get color {
    switch(this) {
      case CLUBS:
      case SPADES:
        return Color.BLACK;
      case DIAMONDS:
      case HEARTS:
        return Color.RED;
    }
    return null;
  }

  final String name;

  const Suit._(this.name);
}
