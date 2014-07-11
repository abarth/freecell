// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of freecell.viewmodel;

class ViewCard extends Card {
  Rectangle lastClientRect;
  bool flyAway = false;
  int flyAwayOrder = 0;
  AnimationPlayer _player;

  Point updateClientRect(Rectangle newClientRect) {
    Rectangle oldClientRect = lastClientRect;
    lastClientRect = newClientRect;
    return oldClientRect == null ? null : newClientRect.topLeft - oldClientRect.topLeft;
  }

  Future animate(Element target, List<Map<String, String>> keyFrames, Map<String, dynamic> timingInfo) {
    if (_player != null)
      _player.cancel();
    _player = WebAnimations.animate(target, keyFrames, timingInfo);
    _player.finish.then((_) {
      _player = null;
    });
    return _player.finish;
  }

  ViewCard(Suit suit, Rank rank) : super(suit, rank) { }
}
