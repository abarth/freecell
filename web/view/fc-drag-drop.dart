library freecell.view.dragdrop;

import "package:polymer/polymer.dart";
import "dart:html";
import "dart:js";
import "dart:math";
import "dart:async";

class FcDragInfo {
  Point delta;

  FcDragInfo(this.delta);
}

class FcDropInfo {
  Point delta;
  Element zone;

  FcDropInfo(this.delta, this.zone);
}

@CustomTag("fc-drag-drop")
class FcDragDrop extends PolymerElement {
  @observable bool dragging = false;

  StreamSubscription trackStartListener;
  StreamSubscription trackListener;
  StreamSubscription trackEndListener;

  FcDragDrop.created() : super.created() {
  }

  void attached() {
    trackStartListener = parentNode.on["trackstart"].listen(handleTrackStart);
    trackListener = parentNode.on["track"].listen(handleTrack);
    trackEndListener = parentNode.on["trackend"].listen(handleTrackEnd);
  }

  void detached() {
    trackStartListener.cancel();
    trackListener.cancel();
    trackEndListener.cancel();
  }

  void handleTrackStart(Event event) {
    dragging = !fire("fc-drag", detail:new FcDragInfo(new Point(0, 0))).defaultPrevented;
  }

  void handleTrack(Event event) {
    if (!dragging)
      return;
    dragging = !fire("fc-drag", detail:new FcDragInfo(_pointFromEvent(event))).defaultPrevented;
  }

  void handleTrackEnd(Event event) {
    if (!dragging)
      return;
    fire("fc-drop", detail:new FcDropInfo(_pointFromEvent(event), _relatedTargetFromEvent(event)));
  }

  Point _pointFromEvent(Event event) {
    JsObject rawEvent = new JsObject.fromBrowserObject(event);
    return new Point(rawEvent["dx"], rawEvent["dy"]);
  }

  Element _relatedTargetFromEvent(Event event) {
    JsObject rawEvent = new JsObject.fromBrowserObject(event);
    return rawEvent["relatedTarget"];
  }
}