// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.viewmodel;

class ViewDeck extends Deck {
  ViewDeck() : super.of(_createCards()) {
  }

  static List<Card> _createCards() {
    List<Card> cards = new List<Card>();
    for (Suit suit in Suit.all){
      for (Rank rank in Rank.all) {
        cards.add(new ViewCard(suit, rank));
      }
    }
    return cards;
  }
}
