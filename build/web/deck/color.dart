// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.deck;

class Color {
  static const Color RED = const Color._(#red);
  static const Color BLACK = const Color._(#black);

  static get all => [RED, BLACK];

  final Symbol value;

  const Color._(this.value);
}
