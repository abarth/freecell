// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.viewmodel;

class ViewDeck extends Deck {
  Card createCard(Suit suit, Rank rank) {
    return new ViewCard(suit, rank);
  }
}
