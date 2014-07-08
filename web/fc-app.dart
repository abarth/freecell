import "package:polymer/polymer.dart";

import "deck/deck.dart";

@CustomTag("fc-app")
class FcApp extends PolymerElement {
  @observable Card card = null;

  FcApp.created() : super.created() {
    this.card = new Card(Suit.HEARTS, new Rank(5));
  }
}
