library freecell.view.solutionplayer;

import "dart:async";

import "../deck/deck.dart";
import "../tableau/tableau.dart";
import "../solver/solution.dart";

import "card-coordinator.dart";

class SolutionPlayer {
  Tableau tableau;
  Solution solution;
  int _nextMove = 0;
  Completer _completer = new Completer();

  SolutionPlayer(this.tableau, this.solution);

  Future play() {
    new Timer.periodic(new Duration(milliseconds: 500), (timer) {
      if (_nextMove >= solution.moves.length) {
        timer.stop();
        _completer.complete();
        return;
      }
      _performMove(solution.moves[_nextMove++]);
    });
    return _completer.future;
  }

  void _performMove(Move move) {
    if (move.count > 1)
      throw "Oops, need fancier logic";

    Pile source = _sourcePile(move);
    Card card = source.cards.last;
    Pile destination = _destiniationPile(move, card);

    assert(source.canTake(card));
    assert(destination.canAccept(card));

    _willRemoveFromPile(card);
    source.cards.remove(card);
    destination.accept(card);
  }

  Pile _sourcePile(Move move) {
    switch (move.sourceType) {
      case "stack":
        return tableau.columns[move.sourceIndex];
      case "freecell":
        return tableau.cells[move.sourceIndex];
    }
    assert(false);
    return null;
  }

  Pile _destiniationPile(Move move, Card card) {
    switch (move.destinationType) {
      case "stack":
        return tableau.columns[move.destinationIndex];
      case "freecell":
        return tableau.cells[move.destinationIndex];
      case "foundations":
        for (Tower tower in tableau.towers) {
          if (tower.canAccept(card))
            return tower;
        }
    }
    assert(false);
    return null;
  }

  void _willRemoveFromPile(Card card) {
    CardCoordinator.instance.viewForCard(card).willRemoveFromPile();
  }
}
