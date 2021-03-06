library freecell.view.card;

import "package:polymer/polymer.dart";
import "dart:async";
import "dart:html";
import "dart:math";

import "../deck/deck.dart";
import "../viewmodel/viewmodel.dart";
import "card-coordinator.dart";

@CustomTag("fc-card")
class FcCard extends PolymerElement {
  @published ViewCard card;
  Completer<FcCard> _completer;
  bool isAttached = false;

  static const double _kSettleVelocity = 1.5; // dips per ms
  static const double _kMinSettleDuration = 200.0; // ms
  static const double _kMaxSettleDuration = 500.0; // ms
  static const double _kFlyAwayDuration = 1500.0; // ms

  FcCard.created() : super.created() {
    attributes["touch-action"] = "none";
  }

  void attached() {
    isAttached = true;
    _registerCard();
  }

  void _playFlyAway() {
    classes.add("moving fly-away");
    Random random = new Random();
    Rectangle rootRect = document.body.getBoundingClientRect();
    Rectangle rect = card.lastClientRect;
    double endX = rootRect.width + rect.width;
    double endY = rootRect.height + rect.height;
    if (random.nextBool())
      endX *= -1;
    endX /= (random.nextInt(5) + 1);
    style.width = rect.width.toString() + "px";
    style.height = rect.height.toString() + "px";
    style.transform = "translate(${rect.left}px, ${rect.top}px)";
    style.zIndex = "${52 - card.flyAwayOrder}";
    style.marginTop = "0";
    async((_) {
      async((_) {
        card.animate(this, [{
          "transform": "translate(${rect.left}px, ${rect.top}px)",
        }, {
          "transform": "translate(${endX}px, ${endY}px)",
        }], {
          "duration": _kFlyAwayDuration,
          "delay": card.flyAwayOrder * 75,
          "easing": "ease-out",
          "fill": "both",
        }).then((_) {
          classes.remove("moving");
        });
      });
    });
  }

  void _playMovement() {
    Point displacement = card.updateClientRect(getBoundingClientRect());
    if (displacement == null)
      return;
    double distance = displacement.magnitude;
    if (distance == 0)
      return;
    double duration = min(max(distance / _kSettleVelocity, _kMinSettleDuration), _kMaxSettleDuration);
    classes.addAll(["moving", "glow"]);
    card.animate(this, [{
      "transform": "translate(${-displacement.x}px, ${-displacement.y}px)",
      "zIndex": "10",
    }, {
      "transform": "translate(0, 0)",
      "zIndex": "10",
    }], {
      "duration": duration,
      "easing": "ease-in-out",
    }).then((_) {
      classes.removeAll(["moving", "glow"]);
      asyncFire("card-movement-end");
    });
  }

  void detached() {
    isAttached = false;
    _unregisterCard();
  }

  void willRemoveFromPile() {
    card.updateClientRect(getBoundingClientRect());
  }

  void cardChanged(Card oldValue, Card newValue) {
    if (!isAttached)
      return;
    _unregisterCard();
    _registerCard();
    // TODO(abarth): Scheduling this work using a microtask isn't quite right
    // because there's not guarantee that we're inside requestAnimationFrame.
    // We might be causing more layouts than necessary. Instead, Polymer needs
    // an API that lets you schedule work to happen before the next frame. The
    // |async| function is almost right, but it will push you to the next frame
    // if it's called inside of requestAnimationFrame.
    if (card == null)
      return;
    scheduleMicrotask(() {
      if (card.flyAway)
        _playFlyAway();
      else
        _playMovement();
    });
  }

  void _registerCard() {
    if (card == null)
      return;
    _completer = new Completer();
    CardCoordinator.instance.addCard(_completer.future);
  }

  void _unregisterCard() {
    if (_completer == null)
      return;
    CardCoordinator.instance.removeCard(_completer.future);
    _completer = null;
  }

  void handleLoad(Event event) {
    _completer.complete(this);
  }

  String get url => formatUrl(card);

  String formatUrl(Card card) {
    return "svg-cards/${ card.rank.value }_of_${ card.suit.name }.svg";
  }
}
