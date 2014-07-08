import "package:polymer/polymer.dart";

import "deck/deck.dart";
import "tableau/tableau.dart";

@CustomTag("fc-pile")
class FcPile extends PolymerElement {
  @published Pile pile;
  @observable Card card;

  FcPile.created() : super.created() {
  }

  void pileChanged(Pile oldValue, Pile newValue) {
    card = pile.cards.isEmpty ? null : pile.cards.last;
  }
}
