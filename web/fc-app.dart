import "package:polymer/polymer.dart";

import "dart:html";

import "deck/deck.dart";
import "tableau/tableau.dart";
import "fc-card.dart";

@CustomTag("fc-app")
class FcApp extends PolymerElement {
  @observable Tableau tableau;

  FcApp.created() : super.created() {
    Deck deck = new Deck();
    deck.shuffle();

    tableau = new Tableau();
    tableau.deal(deck);
    async((double time) {
      $["cardCoordinator"].notifyWhenReady();
    });
  }

  void handleCardsLoaded(CustomEvent event, List<FcCard> cards) {
    cards.forEach((FcCard card) {
      card.hidden = false;
    });
  }

  void handlePlaceCard(CustomEvent event, Card card) {
    for (Tower tower in tableau.towers) {
      if (tower.accept(card)) {
        event.preventDefault();
        return;
      }
    }
    for (Cell cell in tableau.cells) {
      if (cell.accept(card)) {
        event.preventDefault();
        return;
      }
    }
  }
}
