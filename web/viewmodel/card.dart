// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.viewmodel;

class ViewCard extends Card {
  Rectangle lastClientRect;

  Point updateClientRect(Rectangle newClientRect) {
    Point displacement = newClientRect.topLeft - lastClientRect.topLeft;
    lastClientRect = newClientRect;
    return displacement;
  }

  ViewCard(Suit suit, Rank rank) : super(suit, rank) { }
}
