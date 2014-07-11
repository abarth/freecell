library freecell.view.app;

import "package:polymer/polymer.dart";

import "dart:async";
import "dart:html";
import "dart:math";

import "../deck/deck.dart";
import "../tableau/tableau.dart";
import "../viewmodel/viewmodel.dart";
import "../polyfills/webanimations.dart";
import "fc-card.dart";
import "card-coordinator.dart";

@CustomTag("fc-app")
class FcApp extends PolymerElement {
  @observable Tableau tableau;
  @observable String boardForSolver;
  @observable String solution;

  FcApp.created() : super.created() {
    // FIXME: Add UI to enter a seed.
    int seed = new Random().nextInt(51);
    Deck deck = new ViewDeck();
    deck.shuffle(seed);

    CardCoordinator.instance.waitForDeck(deck).then(handleCardsLoaded);

    tableau = new Tableau();
    tableau.deal(deck);

    classes.add("loading");
  }

  void solve() {
    boardForSolver = tableau.serialization;
  }

  void solutionChanged(String oldValue, String newValue) {
    print(solution);
  }

  void handleCardsLoaded(Iterable<FcCard> cards) {
    classes.remove("loading");
    if (window.location.hash != null && window.location.hash.contains("fast"))
      return;
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
