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
    classes.add("animating");
    Rectangle rootRect = getBoundingClientRect();
    int count = cards.length;
    Future.wait(cards.map((FcCard card) {
      Rectangle cardRect = card.getBoundingClientRect();
      double widthOffset = (rootRect.width / 2) - (cardRect.width / 2) - cardRect.left;
      double heightOffset = rootRect.height - cardRect.top;
      return scheduleAnimation(card, [{
        "transform": "translate(${widthOffset}px, ${heightOffset}px)",
      }, {
        "transform": "translate(0, 0)",
      }], {
        "duration": 500,
        "delay": --count * 100,
        "fill": "backwards",
        "easing": "ease-in-out",
      });
    })).then((_) {
      classes.remove("animating");
    });
  }

  Future scheduleAnimation(Element target, List<Map<String, String>> keyFrames, Map<String, dynamic> timingInfo) {
    JsObject object = new JsObject.fromBrowserObject(target).callMethod("animate",
        [new JsObject.jsify(keyFrames), new JsObject.jsify(timingInfo)]);
    Completer completer = new Completer();
    object.callMethod("addEventListener", [() {
      completer.complete();
    }]);
    return completer.future;
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
