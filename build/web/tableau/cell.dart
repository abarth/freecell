// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.tableau;

class Cell extends Pile {
  bool canAccept(Card card) => cards.isEmpty;
  bool canTake(Card card) => true;
}
