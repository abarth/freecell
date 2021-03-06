library freecell.view.pile;

import "package:polymer/polymer.dart";
import "dart:html";
import "dart:async";

import "../deck/deck.dart";
import "../tableau/tableau.dart";

import "fc-card.dart";
import "fc-drag-drop.dart";

@CustomTag("fc-pile")
class FcPile extends PolymerElement {
  @published Pile pile;

  FcPile.created() : super.created() {
  }

  void attached() {
    // FIXME: on-* annotations listen on the ShadowRoot,
    // not the host, so we need to do it here for the
    // super class.
    this.shadowRoots.forEach((String className, ShadowRoot root) {
      root.on["drop-card"].listen(handleDropCard);
      root.on["fc-drag"].listen(handleDrag);
      root.on["fc-drop"].listen(handleDrop);
      root.on["dblclick"].listen(handleDoubleClick);
    });
  }

  void _removeCard(FcCard fcCard) {
    fcCard.willRemoveFromPile();
    pile.cards.remove(fcCard.card);
  }

  void handleDropCard(CustomEvent event) {
    if (pile.accept(event.detail)) {
      event.preventDefault();
      asyncFire("pile-changed");
    }
  }

  void handleDoubleClick(Event event) {
    // It's possible to double-click on a shadow root somehow.
    if (!(event.target is FcCard))
      return;
    FcCard target = event.target;
    Card card = target.card;
    if (!pile.canTake(card))
      return;
    if (!dispatchEvent(new CustomEvent("place-card", detail:card)))
      _removeCard(target);
  }

  void _stopDragging(Element element) {
    element.classes.removeAll(["moving", "glow"]);
    element.style.transform = "";
  }

  void _startDragging(Element element) {
    element.classes.addAll(["moving", "glow"]);
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

    if (target.style.pointerEvents == "")
      _startDragging(target);
    target.style.transform = "translate(${dragInfo.delta.x}px, ${dragInfo.delta.y}px)";
  }

  void handleDrop(CustomEvent event) {
    FcDropInfo dropInfo = event.detail;
    FcCard target = event.target;
    if (!dropInfo.zone.dispatchEvent(new CustomEvent("drop-card", detail:target.card))) {
      _removeCard(target);
    } else {
      target.style.transition = "transform 300ms ease-in-out";
      StreamSubscription listener;
      listener = target.onTransitionEnd.listen((Event event) {
        target.style.transition = "";
        listener.cancel();
      });
    }
    _stopDragging(target);
  }
}