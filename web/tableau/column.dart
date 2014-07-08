// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.tableau;

class Column {
  List<Card> cards;

  Column() {
    cards = new List<Card>();
  }

  bool _canAppend(Card next) {
    if (cards.isEmpty)
      return true;
    Card current = cards.last;
    if (current.rank.value - 1 != next.rank.value)
      return false;
    if (current.suit.color == next.suit.color)
      return false;
    return true;
  }

  bool append(Card card) {
    if (!_canAppend(card))
      return false;
    cards.add(card);
    return true;
  }

  Card take() {
    if (cards.isEmpty)
      return null;
    return cards.removeLast();
  }
}
