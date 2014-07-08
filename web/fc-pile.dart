import "package:polymer/polymer.dart";
import 'dart:html';

import "deck/deck.dart";
import "tableau/tableau.dart";

@CustomTag("fc-pile")
class FcPile extends PolymerElement {
  @published Pile pile;

  FcPile.created() : super.created() {
  }

  void handleDropCard(Event event, Card card) {
    pile.accept(card);
  }
}
