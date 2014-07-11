// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.viewmodel;

class ViewCard extends Card {
  Rectangle lastClientRect;
  bool flyAway = false;

  Point updateClientRect(Rectangle newClientRect) {
    Rectangle oldClientRect = lastClientRect;
    lastClientRect = newClientRect;
    return oldClientRect == null ? null : newClientRect.topLeft - oldClientRect.topLeft;
  }

  ViewCard(Suit suit, Rank rank) : super(suit, rank) { }
}
