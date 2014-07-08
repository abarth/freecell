// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.tableau;

import '../deck/deck.dart';

part 'pile.dart';
part 'column.dart';
part 'cell.dart';
part 'tower.dart';

const int kNumberOfColumns = 8;
const int kNumberOfCells = 4;
const int kNumberOfTowers = 4;

class Tableau {
  List<Column> columns;
  List<Cell> cells;
  List<Tower> towers;

  Tableau() {
    columns = (new Iterable.generate(
        kNumberOfColumns, (i) => new Column())).toList();
    cells = (new Iterable.generate(
        kNumberOfCells, (i) => new Cell())).toList();
    towers = (new Iterable.generate(
        kNumberOfTowers, (i) => new Tower())).toList();
  }

  bool get hasWon {
    return towers.every((tower) => tower.isFull);
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
