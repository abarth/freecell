import "package:polymer/polymer.dart";
import "dart:async";
import "dart:html";

import "deck/deck.dart";
import "fc-card-coordinator.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @published Card card;
  Completer<FcCard> _completer = new Completer();

  FcCard.created() : super.created() {
  }

  void attached() {
    FcCardCoordinator.addCard(_completer.future);
  }

  void detached() {
    FcCardCoordinator.removeCard(_completer.future);
  }

  void handleLoad(Event event) {
    _completer.complete(this);
  }

  String get url => formatUrl(card);

  String formatUrl(Card card) {
    return "svg-cards/${ card.rank.value }_of_${ card.suit.name }.svg";
  }
}
