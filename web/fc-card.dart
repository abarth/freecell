import "package:polymer/polymer.dart";
import "dart:async";
import "dart:html";

import "deck/deck.dart";
import "fc-card-coordinator.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @published Card card;
  Completer<FcCard> _completer;
  bool isAttached = false;

  FcCard.created() : super.created() {
  }

  void attached() {
    isAttached = true;
    _registerCard();
  }

  void detached() {
    isAttached = false;
    _unregisterCard();
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
