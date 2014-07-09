import "package:polymer/polymer.dart";
import "dart:html";
import "dart:async";

import "deck/deck.dart";
import "tableau/tableau.dart";

import "fc-card.dart";
import "fc-drag-drop.dart";

@CustomTag("fc-pile")
class FcPile extends PolymerElement {
  @published Pile pile;

  FcPile.created() : super.created() {
    // FIXME: on-* annotations listen on the ShadowRoot,
    // not the host, so we need to do it here for the
    // super class.
  }

  void attached() {
    this.shadowRoots.forEach((String className, ShadowRoot root) {
      root.on["drop-card"].listen(handleDropCard);
      root.on["fc-drag"].listen(handleDrag);
      root.on["fc-drop"].listen(handleDrop);
      root.on["dblclick"].listen(handleDoubleClick);
    });
  }

  void handleDropCard(CustomEvent event) {
    if (pile.accept(event.detail))
      event.preventDefault();
  }

  void handleDoubleClick(Event event) {
    FcCard target = event.target;
    Card card = target.card;
    if (!pile.canTake(card))
      return;
    if (!dispatchEvent(new CustomEvent("place-card", detail:card)))
      pile.cards.remove(card);
  }

  void _stopDragging(Element element) {
    element.style.setProperty("will-change", "");
    element.style.transform = "";
    element.style.pointerEvents = "";
  }

  void handleDrag(CustomEvent event) {
    FcDragInfo dragInfo = event.detail;
    FcCard target = event.target;
    Card card = target.card;

    if (!pile.canTake(card)) {
      _stopDragging(target);
      event.preventDefault();
      return;
    }

    target.style.setProperty("will-change", "transform");
    target.style.transform = "translate(${dragInfo.delta.x}px, ${dragInfo.delta.y}px)";
    target.style.pointerEvents ="none";
  }

  void handleDrop(CustomEvent event) {
    FcDropInfo dropInfo = event.detail;
    FcCard target = event.target;
    _stopDragging(target);
    if (!dropInfo.zone.dispatchEvent(new CustomEvent("drop-card", detail:target.card))) {
      pile.cards.remove(target.card);
    } else {
      target.style.transition = "transform 300ms ease-in-out";
      StreamSubscription listener;
      listener = target.onTransitionEnd.listen((Event event) {
        target.style.transition = "";
        listener.cancel();
      });
    }
  }
}