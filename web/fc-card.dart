import "package:polymer/polymer.dart";
import 'dart:html';

import "deck/deck.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @published Card card;

  FcCard.created() : super.created() {
  }

  String imageUrl(Card card) {
    return "svg-cards/${ card.rank.value }_of_${ card.suit.name }.svg";
  }

  void handleDragStart(Event event, var detail, Node target) {
    FcCard target = event.target;
    Element avatar = detail["avatar"];

    avatar.style.setProperty("will-change", "transform");

    ImageElement img = document.createElement("img");
    img.src = imageUrl(target.card);

    Rectangle rect = target.getBoundingClientRect();
    img.style.width = "${rect.width}px";
    img.style.height = "${rect.height}px";
    img.style.transform = "translate(-50%, -50%)";

    avatar.append(img);

    detail["drag"] = (var event) {

    };

    detail["drop"] = (var event) {
      img.remove();
    };
  }
}
