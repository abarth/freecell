import "package:polymer/polymer.dart";
import 'dart:html';

import "tableau/tableau.dart";

@CustomTag("fc-pile")
class FcPile extends PolymerElement {
  @published Pile pile;

  FcPile.created() : super.created() {
    // FIXME: on-* annotations listen on the ShadowRoot,
    // not the host, so we need to do it here for the
    // super class.
    on["drop-card"].listen(handleDropCard);
  }

  void handleDropCard(CustomEvent event) {
    pile.accept(event.detail);
  }
}
