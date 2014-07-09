// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.tableau;

abstract class Pile {
  ObservableList<Card> cards;

  Pile() {
    cards = new ObservableList<Card>();
  }

  bool get isEmpty => cards.isEmpty;

  bool _canAccept(Card);
  bool canTake(Card);

  bool accept(Card card) {
    if (!_canAccept(card))
      return false;
    cards.add(card);
    return true;
  }

  void _deal(Card card) {
    cards.add(card);
  }
}
