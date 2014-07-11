// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.tableau;

class Column extends Pile {
  bool _canAccept(Card card) {
    if (cards.isEmpty)
      return true;
    Card current = cards.last;
    return current.rank.value - 1 == card.rank.value
        && current.suit.color != card.suit.color;
  }

  bool canTake(Card card) {
    return !cards.isEmpty && cards.last == card;
  }

  String get serialization {
    String result = ':';
    cards.forEach((card) {
      result += " ${card.serialization}";
    });
    return result;
  }
}
