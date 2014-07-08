import "package:polymer/polymer.dart";

import "deck/deck.dart";
import "tableau/tableau.dart";

@CustomTag("fc-app")
class FcApp extends PolymerElement {
  @observable Tableau tableau;

  FcApp.created() : super.created() {
    Deck deck = new Deck();
    deck.shuffle();

    tableau = new Tableau();
    tableau.deal(deck);
  }
}
