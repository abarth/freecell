import "package:polymer/polymer.dart";

import "deck/deck.dart";
import "tableau/tableau.dart";

@CustomTag("fc-cell")
class FcCell extends PolymerElement {
  @published Cell cell;
  Card card;

  FcCell.created() : super.created() {
    card = new Card(Suit.SPADES, new Rank(5));
  }

  void cellChanged() {
    if (cell.cards.isEmpty)
      card = new Card(Suit.SPADES, new Rank(1));
    else
      card = cell.cards.last;
  }
}
