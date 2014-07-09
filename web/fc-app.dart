import "package:polymer/polymer.dart";

import "dart:html";
import "dart:js";

import "deck/deck.dart";
import "tableau/tableau.dart";

@CustomTag("fc-app")
class FcApp extends PolymerElement {
  @observable Tableau tableau;

  FcApp.created() : super.created() {
    Deck deck = new Deck();
    deck.shuffle();

    tableau = new Tableau();
    tableau.deal(deck);
  }

  void handlePlaceCard(CustomEvent event, Card card) {
    for (Tower tower in tableau.towers) {
      if (tower.accept(card)) {
        event.preventDefault();
        return;
      }
    }
  }
}
