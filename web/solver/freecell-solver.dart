library freecell.solver;

import 'dart:html';
import 'package:web_components/interop.dart' show registerDartType;
import 'package:polymer/polymer.dart' show initMethod;

import 'dart:js';

/// A simple mixin to make it easier to interoperate with the Javascript API of
/// a browser object. This is mainly used by classes that expose a Dart API for
/// Javascript custom elements.
// TODO(sigmund): move this to polymer
class DomProxyMixin {
  JsObject _proxy;
  JsObject get jsElement {
    if (_proxy == null) {
      _proxy = new JsObject.fromBrowserObject(this);
    }
    return _proxy;
  }
}

class FreecellSolver extends HtmlElement with DomProxyMixin {
  FreecellSolver.created() : super.created();

  get board => jsElement['board'];
  set board(value) { jsElement['board'] = value; }

  get solution => jsElement['solution'];
  set solution(value) { jsElement['solution'] = value; }
}
@initMethod
upgradeFreecellSolver() => registerDartType('freecell-solver', FreecellSolver);
