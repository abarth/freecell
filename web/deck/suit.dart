// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.deck;

class Suit {
  static const Suit CLUBS = const Suit._('clubs');
  static const Suit DIAMONDS = const Suit._('diamonds');
  static const Suit HEARTS = const Suit._('hearts');
  static const Suit SPADES = const Suit._('spades');

  static get all => [CLUBS, DIAMONDS, HEARTS, SPADES];

  final String name;

  const Suit._(this.name);
}
