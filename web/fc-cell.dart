import "package:polymer/polymer.dart";

import "deck/deck.dart";
import "tableau/tableau.dart";

@CustomTag("fc-cell")
class FcCell extends PolymerElement {
  @published Cell cell;
  @observable Card card;

  FcCell.created() : super.created() {
  }

  void cellChanged(Cell oldValue, Cell newValue) {
    card = cell.cards.isEmpty ? null : cell.cards.last;
  }
}
