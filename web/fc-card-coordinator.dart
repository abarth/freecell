import "package:polymer/polymer.dart";
import "dart:async";

import "deck/deck.dart";
import "fc-card.dart";

@CustomTag("fc-card-coordinator")
class FcCardCoordinator extends PolymerElement {
  static List<Future<FcCard>> cards = new List();
  static List<FcCardCoordinator> instances = new List();

  static void addCard(Future<FcCard> card) {
    cards.add(card);
  }

  static void removeCard(Future<FcCard> card) {
    cards.remove(card);
  }

  void notifyWhenReady() {
    Future.wait(cards).then((cards) => fire("cards-loaded", detail:cards));
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
