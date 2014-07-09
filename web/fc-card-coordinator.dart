import "package:polymer/polymer.dart";

import "deck/deck.dart";
import "fc-card.dart";

@CustomTag("fc-card-coordinator")
class FcCardCoordinator extends PolymerElement {
  static List<FcCard> cards;
  static List<FcCardCoordinator> instances;

  static void addCard(FcCard card) {
    cards.add(card);
  }

  static void removeCard(FcCard card) {
    cards.remove(card);
  }

  static void notifyInstances(FcCard card) {
    instances.forEach((FcCardCoordinator element) {
      element.fire("card-changed", detail:card);
    });
  }

  static void notifyCards(Card card, String type) {
    cards.forEach((FcCard element) {
      if (element.card == card)
        element.fire(type);
    });
  }

  FcCardCoordinator.created() : super.created() {
  }

  void attached() {
    instances.add(this);
  }

  void detached() {
    instances.remove(this);
  }
}
