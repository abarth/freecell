import "package:polymer/polymer.dart";
import "dart:html";
import "dart:js";
import "dart:math";
import "dart:async";

class FcDragDetail {
  Point location;

  FcDragDetail(this.location);
}

class FcDropDetail {
  Point location;
  Element zone;

  FcDropDetail(this.location, this.zone);
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

  void handleTrackStart(CustomEvent event) {
    this.dragging = true;
  }

  void handleTrack(CustomEvent event) {
    if (!this.dragging)
      return;
    this.fire("fc-drag", detail:new FcDragDetail(_pointFromEvent(event)));
  }

  void handleTrackEnd(CustomEvent event) {
    if (!this.dragging)
      return;
    this.fire("fc-drop", detail:new FcDropDetail(_pointFromEvent(event), _relatedTargetFromEvent(event)));
  }

  Point _pointFromEvent(CustomEvent event) {
    JsObject rawEvent = new JsObject.fromBrowserObject(event);
    return new Point(rawEvent["clientX"], rawEvent["clientY"]);
  }

  Element _relatedTargetFromEvent(CustomEvent event) {
    JsObject rawEvent = new JsObject.fromBrowserObject(event);
    return rawEvent["relatedTarget"];
  }
}