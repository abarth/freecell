import "package:polymer/polymer.dart";

import "deck/deck.dart";
import "fc-card-coordinator.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @published Card card;

  FcCard.created() : super.created() {
  }

  void attached() {
    FcCardCoordinator.addCard(this);
  }

  void detached() {
    FcCardCoordinator.removeCard(this);
  }

  String get url => formatUrl(card);

  String formatUrl(Card card) {
    return "svg-cards/${ card.rank.value }_of_${ card.suit.name }.svg";
  }
}
