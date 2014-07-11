library freecell.view.app;

import "package:polymer/polymer.dart";

import "dart:async";
import "dart:html";
import "dart:math";

import "../deck/deck.dart";
import "../tableau/tableau.dart";
import "../viewmodel/viewmodel.dart";
import "../solver/solution.dart";
import "../polyfills/webanimations.dart";
import "fc-card.dart";
import "card-coordinator.dart";
import "solution-player.dart";

@CustomTag("fc-app")
class FcApp extends PolymerElement {
  @observable Tableau tableau;
  @observable String boardForSolver;
  @observable String boardId;
  @observable int remainingCards;

  FcApp.created() : super.created() {
    boardId = (new Random().nextInt(pow(2, 32)) + 1).toString();
    deal();
  }

  void deal() {
    // For some reason thre is no 0th deal.
    int seed = int.parse(boardId);
    if (seed == 0)
      return;

    remainingCards = 52;

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

  void handleFreecellSolved(CustomEvent event, String solution) {
    SolutionPlayer player = new SolutionPlayer(tableau, new Solution.parse(solution));
    player.play().then((_) {
      handlePileChanged();
    });
  }

  void handlePileChanged() {
    remainingCards = 52;
    tableau.towers.forEach((tower) {
      remainingCards -= tower.cards.length;
    });
    if (remainingCards == 0)
      _flyAwayCards();
  }

  void _flyAwayCards() {
    Random random = new Random();
    CardCoordinator.instance.cards.then((List<FcCard> fcCards) {
      fcCards.forEach((fcCard) {
        ViewCard card = fcCard.card;
        if (card == null || card.flyAway)
          return;
        card.flyAway = true;
        fcCard.willRemoveFromPile();
        tableau.towers.forEach((tower) {
          tower.cards.remove(card);
        });
        tableau.columns[random.nextInt(kNumberOfColumns)].cards.add(card);
      });
      if (tableau.towers.any((tower) => !tower.isEmpty)) {
        async((_) {
          _flyAwayCards();
        });
      }
    });
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
        asyncFire("pile-changed");
        return;
      }
    }
    for (Cell cell in tableau.cells) {
      if (cell.accept(card)) {
        event.preventDefault();
        asyncFire("pile-changed");
        return;
      }
    }
  }
}
