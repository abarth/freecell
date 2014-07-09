import "package:polymer/polymer.dart";
import "dart:html";
import "dart:js";
import "dart:math";
import "dart:async";

class FcDragInfo {
  Point location;

  FcDragInfo(this.location);
}

class FcDropInfo {
  Point location;
  Element zone;

  FcDropInfo(this.location, this.zone);
}

@CustomTag("fc-drag-drop")
class FcDragDrop extends PolymerElement {
  @observable bool dragging = false;

  Point _start;

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
    dragging = true;
    _start = _pointFromEvent(event);
    fire("fc-drag", detail:new FcDragInfo(new Point(0, 0)));
  }

  void handleTrack(Event event) {
    if (!dragging)
      return;
    Point location = _pointFromEvent(event);
    if (fire("fc-drag", detail:new FcDragInfo(location - _start)).defaultPrevented)
      dragging = false;
  }

  void handleTrackEnd(Event event) {
    if (!dragging)
      return;
    Point location = _pointFromEvent(event);
    fire("fc-drop", detail:new FcDropInfo(location - _start, _relatedTargetFromEvent(event)));
  }

  Point _pointFromEvent(Event event) {
    JsObject rawEvent = new JsObject.fromBrowserObject(event);
    return new Point(rawEvent["clientX"], rawEvent["clientY"]);
  }

  Element _relatedTargetFromEvent(Event event) {
    JsObject rawEvent = new JsObject.fromBrowserObject(event);
    return rawEvent["relatedTarget"];
  }
}