// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.tableau;

import '../deck/deck.dart';

part 'pile.dart';
part 'column.dart';
part 'cell.dart';

const int kNumberOfColumns = 8;
const int kNumberOfCells = 4;

class Tableau {
  List<Column> columns;
  List<Cell> cells;

  Tableau() {
    columns = new List<Column>.from(
        new Iterable.generate(kNumberOfColumns, (i) => new Column()));
    cells = new List<Cell>.from(
        new Iterable.generate(kNumberOfCells, (i) => new Cell()));
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
