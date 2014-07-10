import "package:polymer/polymer.dart";

import "dart:async";
import "dart:html";
import "dart:js";

import "deck/deck.dart";
import "tableau/tableau.dart";
import "fc-card.dart";
import "fc-card-coordinator.dart";


@CustomTag("fc-app")
class FcApp extends PolymerElement {
  @observable Tableau tableau;

  FcApp.created() : super.created() {
    Deck deck = new Deck();
    deck.shuffle();

    CardCoordinator.instance.waitForDeck(deck).then(handleCardsLoaded);

    tableau = new Tableau();
    tableau.deal(deck);

    classes.add("loading");
  }

  void handleCardsLoaded(Iterable<FcCard> cards) {
    classes.remove("loading");
    Rectangle root = getBoundingClientRect();
    cards.forEach((FcCard card) {
      Rectangle rect = card.getBoundingClientRect();
      scheduleAnimation(card, [{
        "transform": "translate(-1000px, 5000px)",
      }, {
        "transform": "translate(0, 0)",
      }], {
        "duration": 300,
        "easing": "ease-in-out",
      });
    });
  }

  void scheduleAnimation(Element target, List<Map<String, String>> keyFrames, Map<String, dynamic> timingInfo) {
    new JsObject.fromBrowserObject(target).callMethod("animate",
        [new JsObject.jsify(keyFrames), new JsObject.jsify(timingInfo)]);
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
