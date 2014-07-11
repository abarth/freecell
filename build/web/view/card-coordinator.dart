library freecell.view.cardcoordinator;

import "dart:async";
import "dart:collection";

import '../deck/deck.dart';
import 'fc-card.dart';

class CardCoordinator {
  List<Future<FcCard>> _fcCards;
  LinkedHashMap<Card, FcCard> _cards;
  int _count = 0;
  Completer _completer;

  static final CardCoordinator instance = new CardCoordinator();

  FcCard viewForCard(Card card) => _cards[card];

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

  Future<List<FcCard>> get fcCards => Future.wait(_fcCards);
  Iterable<Card> get cards => _cards.keys;

  Future waitForDeck(Deck deck) {
    _fcCards = new List();
    _count = 0;
    _completer = new Completer();
    _cards = new LinkedHashMap.fromIterable(deck.cards,
            value:(value) { return null; });
    return _completer.future;
  }
}
