import "package:polymer/polymer.dart";
import 'dart:html';
import 'dart:js';

import "deck/deck.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @published Card card;

  FcCard.created() : super.created() {
  }

  String imageUrl(Card card) {
    return "svg-cards/${ card.rank.value }_of_${ card.suit.name }.svg";
  }

  void handleDragStart(Event event, JsObject dragInfo, Node target) {
    FcCard target = event.target;
    Element avatar = dragInfo["avatar"];

    // FIXME: The card has a funny clipping rect when dragging.
    avatar.style.setProperty("will-change", "transform");

    ImageElement img = document.createElement("img");
    img.src = imageUrl(target.card);

    Rectangle rect = target.getBoundingClientRect();
    img.style.width = "${rect.width}px";
    img.style.height = "${rect.height}px";
    img.style.transform = "translate(-50%, -50%)";

    avatar.append(img);

    dragInfo["drag"] = (var dragInfo) {

    };

    dragInfo["drop"] = (var dragInfo) {
      // FIXME: Polymer adds this expando, but dart won't let me get it
      // since it's an expando.
      var event = new JsObject.fromBrowserObject(dragInfo["event"]);
      Element relatedTarget = event["relatedTarget"];
      relatedTarget.dispatchEvent(new CustomEvent("drop-card", detail:this.card));
      img.remove();
    };
  }
}
