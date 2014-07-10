library freecell.cardcoordinator;

import "dart:async";

import "deck/deck.dart";
import "fc-card.dart";

class CardCoordinator {
  List<Future<FcCard>> _fcCards = new List();
  Set<Card> _cards;
  Completer _completer = new Completer();

  static final CardCoordinator instance = new CardCoordinator();

  void addCard(Future<FcCard> future) {
    _fcCards.add(future);
    future.then((card) {
      _cards.remove(card.card);
      if (_cards.isEmpty)
        _completer.complete(Future.wait(_fcCards));
    });
  }

  void removeCard(Future<FcCard> future) {
    _fcCards.remove(future);
  }

  Future waitForDeck(Deck deck) {
    _cards = deck.cards;
    return _completer.future;
  }
}
