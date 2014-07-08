// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.tableau;

abstract class Pile {
  List<Card> cards;

  Pile() {
    cards = new List<Card>();
  }

  bool _canAccept(Card);
  bool _canTake();

  bool accept(Card card) {
    if (!_canAccept(card))
      return false;
    cards.add(card);
    return true;
  }

  Card take() {
    if (cards.isEmpty)
      return null;
    if (!_canTake())
      return null;
    return cards.removeLast();
  }

  void _deal(Card card) {
    cards.add(card);
  }
}
