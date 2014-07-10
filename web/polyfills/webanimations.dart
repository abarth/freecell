// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library freecell.webanimations;

import "dart:js";
import "dart:async";
import "dart:html";

class WebAnimations {
  static Future animate(Element target, List<Map<String, String>> keyFrames, Map<String, dynamic> timingInfo) {
    JsObject object = new JsObject.fromBrowserObject(target);
    if (!object.hasProperty("animate"))
      return new Future.value();
    JsObject player = object.callMethod("animate",
        [new JsObject.jsify(keyFrames), new JsObject.jsify(timingInfo)]);
    Completer completer = new Completer();
    player.callMethod("addEventListener", ["finish", (event) {
      completer.complete();
    }]);
    return completer.future;
  }
}
