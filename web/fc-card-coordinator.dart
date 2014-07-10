library freecell.cardcoordinator;

import "dart:async";
import "dart:collection";

import "deck/deck.dart";
import "fc-card.dart";

class CardCoordinator {
  List<Future<FcCard>> _fcCards = new List();
  LinkedHashMap<Card, FcCard> _cards;
  int _count = 0;
  Completer _completer = new Completer();

  static final CardCoordinator instance = new CardCoordinator();

  void addCard(Future<FcCard> future) {
    _fcCards.add(future);
    future.then((fcCard) {
      _cards[fcCard.card] = fcCard;
      _count++;
      if (_count == _cards.length)
          _completer.complete(_cards.values);
    });
  }

  void removeCard(Future<FcCard> future) {
    _fcCards.remove(future);
  }

  Future waitForDeck(Deck deck) {
    _cards = new LinkedHashMap.fromIterable(deck.cards,
        value:(value) { return null; });
    return _completer.future;
  }
}
