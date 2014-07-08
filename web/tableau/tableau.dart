// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.tableau;

import '../deck/deck.dart';

part 'column.dart';

const int kNumberOfColumns = 8;

class Tableau {
  List<Column> columns;

  Tableau() {
    columns = new List<Column>.from(
        new Iterable.generate(kNumberOfColumns, (i) => new Column()));
  }
}
