import "package:polymer/polymer.dart";
import "dart:html";
import "dart:js";

import "deck/deck.dart";
import "tableau/tableau.dart";

import "fc-card.dart";

@CustomTag("fc-pile")
class FcPile extends PolymerElement {
  @published Pile pile;

  FcPile.created() : super.created() {
    // FIXME: on-* annotations listen on the ShadowRoot,
    // not the host, so we need to do it here for the
    // super class.
  }

  void attached() {
    this.shadowRoots.forEach((String className, ShadowRoot root) {
      root.on["drop-card"].listen(handleDropCard);
      root.on["drag-start"].listen(handleDragStart);
    });
  }

  void handleDropCard(CustomEvent event) {
    if (pile.accept(event.detail))
      event.preventDefault();
  }

  void handleDragStart(CustomEvent event) {
    JsObject dragInfo = new JsObject.fromBrowserObject(event)["detail"];
    FcCard target = event.target;
    Element avatar = dragInfo["avatar"];
    Card card = target.card;

    if (!pile.canTake(card))
      return;

    // FIXME: The card has a funny clipping rect when dragging.
    avatar.style.setProperty("will-change", "transform");

    ImageElement img = document.createElement("img");
    img.src = target.url;

    Rectangle rect = target.getBoundingClientRect();
    img.style.width = "${rect.width}px";
    img.style.height = "${rect.height}px";
    img.style.transform = "translate(-50%, -50%)";

    avatar.append(img);

    dragInfo["drag"] = (var dragInfo) {
      target.style.visibility = "hidden";
    };

    dragInfo["drop"] = (var dragInfo) {
      // FIXME: Polymer adds this expando, but dart won't let me get it
      // since it's an expando.
      var event = new JsObject.fromBrowserObject(dragInfo["event"]);
      Element relatedTarget = event["relatedTarget"];
      if (!relatedTarget.dispatchEvent(new CustomEvent("drop-card", detail:target.card)))
        pile.cards.remove(target.card);
      target.style.visibility = "";
      img.remove();
    };
  }
}
