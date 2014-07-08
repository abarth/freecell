// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.tableau;

import '../deck/deck.dart';

part 'pile.dart';
part 'column.dart';

const int kNumberOfColumns = 8;

class Tableau {
  List<Column> columns;

  Tableau() {
    columns = new List<Column>.from(
        new Iterable.generate(kNumberOfColumns, (i) => new Column()));
  }

  void deal(Deck deck) {
    int i = 0;
    while (!deck.isEmpty) {
      Card card = deck.takeNext();
      columns[i]._deal(card);
      i = (i + 1) % kNumberOfColumns;
    }
  }
}
