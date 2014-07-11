// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.deck;

import 'dart:math';

part 'card.dart';
part 'color.dart';
part 'msrandom.dart';
part 'rank.dart';
part 'suit.dart';

class Deck {
  List<Card> _cards;

  Deck() {
    _cards = new List<Card>();
    for (Rank rank in Rank.all) {
      for (Suit suit in Suit.all){
        _cards.add(createCard(suit, rank));
      }
    }
  }

  Card createCard(Suit suit, Rank rank) {
    return new Card(suit, rank);
  }

  Deck.of(List<Card> cards) {
    _cards = new List.from(cards);
  }

  List<Card> get cards => new List.from(_cards);

  void shuffle(int seed) {
    if (_cards.isEmpty)
      return;
    var i = _cards.length;
    var random = new MSRandom(seed);
    while (--i > 0) {
        int j = random.nextInt(i + 1);
        Card card= _cards[i];
        _cards[i] = _cards[j];
        _cards[j] = card;
    }
    _cards = new List.from(_cards.reversed);
  }

  bool get isEmpty => _cards.isEmpty;

  Card takeNext() {
    return _cards.removeLast();
  }
}
