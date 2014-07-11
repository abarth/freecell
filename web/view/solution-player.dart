library freecell.view.solutionplayer;

import "dart:async";

import "../deck/deck.dart";
import "../tableau/tableau.dart";
import "../solver/solution.dart";

import "card-coordinator.dart";

class Transfer {
  final Pile source;
  final Pile destination;

  Transfer(this.source, this.destination);
}

class CompoundMovePlanner {
  Tableau tableau;
  List<Pile> freeCells;
  List<Pile> freeColumns;

  CompoundMovePlanner(this.tableau) {
    freeCells = _findFree(tableau.cells);
    freeColumns = _findFree(tableau.columns);
  }

  static List<Pile> concat(List<Pile> a, List<Pile> b) {
    List<Pile> result = new List.from(a);
    result.addAll(b);
    return result;
  }

  List<Pile> _findFree(List<Pile> piles) {
    List<Pile> result = new List<Pile>();
    for (Pile pile in piles) {
      if (pile.isEmpty)
        result.add(pile);
    }
    return result;
  }

  List<Transfer> plan(Transfer transfer, int count) {
    List<Pile> availableColumns = new List.from(freeColumns);
    availableColumns.remove(transfer.destination);
    return _createRecursivePlan(transfer, count, availableColumns);
  }

  List<Transfer> _createRecursivePlan(Transfer transfer, int count, List<Pile> availableColumns) {
    if (count <= freeCells.length + availableColumns.length + 1)
      return _createSimplePlan(transfer, count, concat(freeCells, availableColumns));

    List<Pile> childAvailableColumns = new List.from(availableColumns);
    Pile pivot = childAvailableColumns.removeLast();

    Transfer pivotTransfer = new Transfer(transfer.source, pivot);
    Transfer unpivotTransfer = new Transfer(pivot, transfer.destination);

    int pivotCount = freeCells.length + childAvailableColumns.length + 1;
    List<Pile> pivotTemporaries = concat(freeCells, childAvailableColumns);

    List<Transfer> plan = _createSimplePlan(pivotTransfer, pivotCount, pivotTemporaries);
    plan.addAll(_createRecursivePlan(transfer, count - pivotCount, childAvailableColumns));
    plan.addAll(_createSimplePlan(unpivotTransfer, pivotCount, pivotTemporaries));
    return plan;
  }

  List<Transfer> _createSimplePlan(Transfer transfer, int count, List<Pile> temporaries) {
    assert(!temporaries.contains(transfer.source));
    assert(!temporaries.contains(transfer.destination));

    List<Transfer> plan = new List<Transfer>();

    int nextTemporary = 0;
    for (int i = 0; i < count - 1; ++i)
      plan.add(new Transfer(transfer.source, temporaries[nextTemporary++]));

    plan.add(transfer);

    while (nextTemporary > 0)
      plan.add(new Transfer(temporaries[--nextTemporary], transfer.destination));

    return plan;
  }
}

class SolutionPlayer {
  static final _moveDelay = new Duration(milliseconds: 500);

  Tableau tableau;

  Solution solution;
  int _nextMove = 0;

  List<Transfer> _compoundPlan;
  int _nextStepInCompoundPlan = -1;

  Completer _completer = new Completer();

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
      CompoundMovePlanner planner = new CompoundMovePlanner(tableau);
      _compoundPlan = planner.plan(_planSimpleMove(move), move.count);
      _nextStepInCompoundPlan = 0;
      _performNextStepInCompoundPlan();
      return;
    }

    _executeSimplePlan(_planSimpleMove(move));
    _scheduleNextMove();
  }

  Transfer _planSimpleMove(Move move) {
    Pile source = _sourcePile(move);
    Card card = source.cards.last;
    Pile destination = _destiniationPile(move, card);
    return new Transfer(source, destination);
  }

  void _executeSimplePlan(Transfer transfer) {
    Card card = transfer.source.cards.last;

    assert(transfer.source.canTake(card));
    assert(transfer.destination.canAccept(card));

    _willRemoveFromPile(card);
    transfer.destination.accept(card);
    transfer.source.cards.remove(card);
  }

  void _performNextStepInCompoundPlan() {
    if (_nextStepInCompoundPlan >= _compoundPlan.length) {
      _compoundPlan = null;
      _nextStepInCompoundPlan = -1;
      _performNextMove();
      return;
    }
    _executeSimplePlan(_compoundPlan[_nextStepInCompoundPlan++]);
    new Timer(_moveDelay, _performNextStepInCompoundPlan);
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
