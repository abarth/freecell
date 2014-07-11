// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.webanimations;

import "dart:js";
import "dart:async";
import "dart:html";

class AnimationPlayer {
  JsObject _player;
  Future finish;

  AnimationPlayer(JsObject this._player) {
    Completer completer = new Completer();
    _player.callMethod("addEventListener", ["finish", (event) {
      completer.complete();
    }]);
    finish = completer.future;
  }

  AnimationPlayer.stub() {
    finish = new Future.value();
  }

  void cancel() {
    if (_player != null)
      _player.callMethod("cancel");
  }
}

class WebAnimations {
  static AnimationPlayer animate(Element target, List<Map<String, String>> keyFrames, Map<String, dynamic> timingInfo) {
    JsObject object = new JsObject.fromBrowserObject(target);
    if (!object.hasProperty("animate"))
      return new AnimationPlayer.stub();
    return new AnimationPlayer(object.callMethod("animate",
        [new JsObject.jsify(keyFrames), new JsObject.jsify(timingInfo)]));
  }
}
