import "package:polymer/polymer.dart";

import "deck/deck.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @published Card card = null;

  FcCard.created() : super.created() {
  }
}

