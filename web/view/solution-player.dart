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

  static final _moveDelay = new Duration(milliseconds: 500);

  SolutionPlayer(this.tableau, this.solution);

  Future play() {
    new Timer.periodic(_moveDelay, (timer) {
      if (_nextMove >= solution.moves.length) {
        timer.cancel();
        _completer.complete();
        return;
      }
      _performMove(solution.moves[_nextMove++]);
    });
    return _completer.future;
  }

  void _performMove(Move move) {
    if (move.count > 1)
      return _performCompoundMove(move);

    Pile source = _sourcePile(move);
    Card card = source.cards.last;
    Pile destination = _destiniationPile(move, card);

    _transferCard(card, source, destination);
  }

  void _performCompoundMove(Move move) {
    assert(move.count > 1);
    assert(move.sourceType == 'stack');
    assert(move.destinationType == 'stack');

    Pile source = _sourcePile(move);
    Pile destination = _destiniationPile(move, null);

    List<Cell> usedCells = new List<Cell>();

    for (int i = 0; i < move.count - 1; ++i) {
      Card card = source.cards.last;
      Cell freeCell = _findFreeCell(card);
      usedCells.add(freeCell);
      _transferCard(card, source, freeCell);
    }

    _transferCard(source.cards.last, source, destination);

    for (int i = usedCells.length - 1; i >= 0; --i) {
      Cell cell = usedCells[i];
      _transferCard(cell.cards.last, cell, destination);
    }
  }

  void _transferCard(Card card, Pile source, Pile destination) {
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

  Cell _findFreeCell(Card card) {
    for (Cell cell in tableau.cells) {
      if (cell.canAccept(card))
        return cell;
    }
    assert(false);
    return null;
  }

  void _willRemoveFromPile(Card card) {
    CardCoordinator.instance.viewForCard(card).willRemoveFromPile();
  }
}
