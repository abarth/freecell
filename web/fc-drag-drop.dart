import "package:polymer/polymer.dart";
import "dart:html";
import "dart:async";

@CustomTag("fc-drag-drop")
class FcDragDrop extends PolymerElement {
  bool dragging = false;
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
    this.fire("drag-start");
    this.dragging = true;
  }

  void handleTrack(Event event) {
    if (!this.dragging)
      return;
    // FIXME: Compute the x, y here and call drag().
  }

  void handleTrackEnd(Event event) {
    if (!this.dragging)
      return;
    this.dragging = false;
    // FIXME: Call drop().
  }
}