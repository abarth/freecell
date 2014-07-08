import "package:polymer/polymer.dart";

import "deck/deck.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @observable Card card;

  FcCard.created() : super.created() {
  }
}
