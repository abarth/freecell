// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.solution;

class Move {
  static final RegExp _regexp =
      new RegExp(r"^Move (\w+) cards? from (\w+) (\w+) to (\w+) (\w+)$");

  int count;
  String sourceType;
  int sourceIndex;
  String destinationType;
  int destinationIndex;

  Move.parse(String move) {
    Match match = _regexp.firstMatch(move);
    if (match == null)
      throw "Failed to parse move: " + move;

    String countStr = match.group(1);
    count = countStr == 'a' ? 1 : int.parse(countStr);

    sourceType = match.group(2);
    sourceIndex = int.parse(match.group(3));

    destinationType = match.group(4);
    String destinationIndexStr = match.group(5);

    if (destinationType == 'the' && destinationIndexStr == 'foundations') {
      destinationType = 'foundations';
      destinationIndex = -1;
    } else {
      destinationIndex = int.parse(destinationIndexStr);
    }
  }
}

class Solution {
  List<Move> moves;

  Solution.parse(String solution) {
    moves = solution.split('\n').map((move) => new Move.parse(move)).toList();
  }
}
