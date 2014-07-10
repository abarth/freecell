import "package:polymer/polymer.dart";

import "dart:async";
import "dart:html";

import "deck/deck.dart";
import "tableau/tableau.dart";
import "viewmodel/viewmodel.dart";
import "polyfills/webanimations.dart";
import "fc-card.dart";
import "fc-card-coordinator.dart";

@CustomTag("fc-app")
class FcApp extends PolymerElement {
  @observable Tableau tableau;

  FcApp.created() : super.created() {
    Deck deck = new ViewDeck();
    deck.shuffle();

    CardCoordinator.instance.waitForDeck(deck).then(handleCardsLoaded);

    tableau = new Tableau();
    tableau.deal(deck);

    classes.add("loading");
  }

  void handleCardsLoaded(Iterable<FcCard> cards) {
    classes.remove("loading");
    classes.add("animating");
    Rectangle rootRect = getBoundingClientRect();
    int count = cards.length;
    Future.wait(cards.map((FcCard card) {
      Rectangle cardRect = card.getBoundingClientRect();
      double widthOffset = (rootRect.width / 2) - (cardRect.width / 2) - cardRect.left;
      double heightOffset = rootRect.height - cardRect.top;
      return WebAnimations.animate(card, [{
        "transform": "translate(${widthOffset}px, ${heightOffset}px)",
        "zIndex": "${count}",
      }, {
        "transform": "translate(0, 0)",
        "zIndex": "${count}"
      }], {
        "duration": 300,
        "delay": --count * 75,
        "fill": "backwards",
        "easing": "ease-in-out",
      });
    })).then((_) {
      classes.remove("animating");
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
