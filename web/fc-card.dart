import "package:polymer/polymer.dart";
import "dart:async";
import "dart:html";

import "deck/deck.dart";
import "viewmodel/viewmodel.dart";
import "polyfills/webanimations.dart";
import "fc-card-coordinator.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @published ViewCard card;
  Completer<FcCard> _completer;
  bool isAttached = false;

  FcCard.created() : super.created() {
  }

  void attached() {
    isAttached = true;
    _registerCard();
    async((_) {
      Point displacement = card.updateClientRect(getBoundingClientRect());
      if (displacement == null)
        return;
      WebAnimations.animate(this, [{
        "transform": "translate(${-displacement.x}px, ${-displacement.y}px)"
      }, {
        "transform": "translate(0, 0)",
      }], {
        "duration": 400,
        "easing": "ease-in-out",
      });
    });
  }

  void detached() {
    isAttached = false;
    _unregisterCard();
  }

  void willRemoveFromPile() {
    card.updateClientRect(getBoundingClientRect());
  }

  void cardChanged(Card oldValue, Card newValue) {
    if (!isAttached)
      return;
    _unregisterCard();
    _registerCard();
  }

  void _registerCard() {
    if (card == null)
      return;
    _completer = new Completer();
    CardCoordinator.instance.addCard(_completer.future);
  }

  void _unregisterCard() {
    if (_completer == null)
      return;
    CardCoordinator.instance.removeCard(_completer.future);
    _completer = null;
  }

  void handleLoad(Event event) {
    _completer.complete(this);
  }

  String get url => formatUrl(card);

  String formatUrl(Card card) {
    return "svg-cards/${ card.rank.value }_of_${ card.suit.name }.svg";
  }
}
