// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.tableau;

class Tower extends Pile {
  bool canAccept(Card card) {
    if (cards.isEmpty)
      return card.rank.value == 1;
    Card current = cards.last;
    return current.rank.value + 1 == card.rank.value
        && current.suit == card.suit;
  }

  bool canTake(Card card) => false;

  bool get isFull => cards.length == 13;
}
