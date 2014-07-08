// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.deck;

import 'dart:math';

part 'suit.dart';
part 'rank.dart';
part 'card.dart';

class Deck {
  List<Card> _cards;

  Deck() {
    _cards = new List<Card>();
    for (Suit suit in Suit.all){
      for (Rank rank in Rank.all) {
        _cards.add(new Card(suit, rank));
      }
    }
  }

<<<<<<< Updated upstream
  void shuffle() {
=======
  shuffle() {
    if (_cards.isEmpty)
      return;
>>>>>>> Stashed changes
    Random rng = new Random();
    for (int i = _cards.length - 1; i > 0; --i) {
      int nextIndex = rng.nextInt(i);
      Card nextCard = _cards[nextIndex];
      _cards[nextIndex] = _cards[i];
      _cards[i] = nextCard;
    }
  }

  Card takeNext() {
    return _cards.removeLast();
  }
}
