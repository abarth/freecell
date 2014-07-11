library freecell.view.solutionplayer;

import "dart:async";

import "../deck/deck.dart";
import "../tableau/tableau.dart";
import "../solver/solution.dart";

import "card-coordinator.dart";

class _CompoundMoveState {
  Move move;
  List<Pile> temporaries = new List<Pile>();
  int windStep = 0;
  int unwindStep = 0;
  bool needsHeroStep = true;

  _CompoundMoveState(this.move);
}

class SolutionPlayer {
  static final _moveDelay = new Duration(milliseconds: 100);

  Tableau tableau;
  Solution solution;
  int _nextMove = 0;
  Completer _completer = new Completer();
  _CompoundMoveState _compoundState;

  SolutionPlayer(this.tableau, this.solution);

  Future play() {
    _scheduleNextMove();
    return _completer.future;
  }

  void _scheduleNextMove() {
    new Timer(_moveDelay, _performNextMove);
  }

  void _performNextMove() {
    if (_nextMove >= solution.moves.length) {
      _completer.complete();
      return;
    }
    _performMove(solution.moves[_nextMove++]);
  }

  void _performMove(Move move) {
    if (move.count > 1) {
      _compoundState = new _CompoundMoveState(move);
      _performCompoundMoveStep();
      return;
    }

    Pile source = _sourcePile(move);
    Card card = source.cards.last;
    Pile destination = _destiniationPile(move, card);

    _transferCard(card, source, destination);
    _scheduleNextMove();
  }

  void _scheduleCompoundMoveStep() {
    new Timer(_moveDelay, _performCompoundMoveStep);
  }

  void _performCompoundMoveStep() {
    Move move = _compoundState.move;

    assert(move.count > 1);
    assert(move.sourceType == 'stack');
    assert(move.destinationType == 'stack');

    Pile source = _sourcePile(move);
    Pile destination = _destiniationPile(move, null);

    while (_compoundState.windStep < move.count - 1) {
      Card card = source.cards.last;
      Pile temporary = _findTempory(card, destination);
      _compoundState.temporaries.add(temporary);
      _transferCard(card, source, temporary);
      ++_compoundState.windStep;
      _scheduleCompoundMoveStep();
      return;
    }

    if (_compoundState.needsHeroStep) {
      _transferCard(source.cards.last, source, destination);
      _compoundState.needsHeroStep = false;
      _scheduleCompoundMoveStep();
      return;
    }

    while (_compoundState.unwindStep < _compoundState.temporaries.length) {
      Pile temporary = _compoundState.temporaries[_compoundState.temporaries.length - _compoundState.unwindStep - 1];
      _transferCard(temporary.cards.last, temporary, destination);
      ++_compoundState.unwindStep;
      _scheduleCompoundMoveStep();
      return;
    }

    _compoundState = null;
    _performNextMove();
  }

  void _transferCard(Card card, Pile source, Pile destination) {
    assert(source.canTake(card));
    assert(destination.canAccept(card));

    // _willRemoveFromPile(card);
    destination.accept(card);
    source.cards.remove(card);
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

  Pile _findTempory(Card card, Pile excluded) {
    for (Cell cell in tableau.cells) {
      if (cell.canAccept(card))
        return cell;
    }
    for (Column column in tableau.columns) {
      if (!column.isEmpty || column == excluded)
        continue;
      if (column.canAccept(card))
        return column;
    }
    assert(false);
    return null;
  }

  void _willRemoveFromPile(Card card) {
    CardCoordinator.instance.viewForCard(card).willRemoveFromPile();
  }
}
