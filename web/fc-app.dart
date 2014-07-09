import "package:polymer/polymer.dart";

import "dart:html";
import "dart:js";

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
    classes.add("loading");
    async((double time) {
      $["cardCoordinator"].notifyWhenReady();
    });
  }

  void handleCardsLoaded(CustomEvent event, List<FcCard> cards) {
    classes.remove("loading");
  }

  void playAnimation(Element target, List<Map<String, String>> keyFrames, Map<String, dynamic> timingInfo) {
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
