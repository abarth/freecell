library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'solver/freecell-solver.dart' as i0;
import 'view/fc-drag-drop.dart' as i1;
import 'view/fc-card.dart' as i2;
import 'view/fc-pile.dart' as i3;
import 'view/fc-collapsed-pile.dart' as i4;
import 'view/fc-column.dart' as i5;
import 'view/fc-app.dart' as i6;
import 'freecell.html.0.dart' as i7;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'view/fc-drag-drop.dart' as smoke_0;
import 'package:polymer/polymer.dart' as smoke_1;
import 'package:observe/src/metadata.dart' as smoke_2;
import 'view/fc-card.dart' as smoke_3;
import 'viewmodel/viewmodel.dart' as smoke_4;
import 'view/fc-pile.dart' as smoke_5;
import 'tableau/tableau.dart' as smoke_6;
import 'view/fc-collapsed-pile.dart' as smoke_7;
import 'view/fc-column.dart' as smoke_8;
import 'view/fc-app.dart' as smoke_9;
abstract class _M0 {} // PolymerElement & ChangeNotifier

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #boardForSolver: (o) => o.boardForSolver,
        #boardId: (o) => o.boardId,
        #card: (o) => o.card,
        #cardChanged: (o) => o.cardChanged,
        #cards: (o) => o.cards,
        #cell: (o) => o.cell,
        #cells: (o) => o.cells,
        #column: (o) => o.column,
        #columns: (o) => o.columns,
        #deal: (o) => o.deal,
        #dragging: (o) => o.dragging,
        #enumerate: (o) => o.enumerate,
        #formatUrl: (o) => o.formatUrl,
        #handleCardMovementEnd: (o) => o.handleCardMovementEnd,
        #handleFreecellSolved: (o) => o.handleFreecellSolved,
        #handleLoad: (o) => o.handleLoad,
        #handlePileChanged: (o) => o.handlePileChanged,
        #handlePlaceCard: (o) => o.handlePlaceCard,
        #index: (o) => o.index,
        #isEmpty: (o) => o.isEmpty,
        #item: (o) => o.item,
        #length: (o) => o.length,
        #newBoard: (o) => o.newBoard,
        #pile: (o) => o.pile,
        #remainingCards: (o) => o.remainingCards,
        #solve: (o) => o.solve,
        #tableau: (o) => o.tableau,
        #tower: (o) => o.tower,
        #towers: (o) => o.towers,
        #value: (o) => o.value,
      },
      setters: {
        #boardForSolver: (o, v) { o.boardForSolver = v; },
        #boardId: (o, v) { o.boardId = v; },
        #card: (o, v) { o.card = v; },
        #cell: (o, v) { o.cell = v; },
        #column: (o, v) { o.column = v; },
        #dragging: (o, v) { o.dragging = v; },
        #pile: (o, v) { o.pile = v; },
        #remainingCards: (o, v) { o.remainingCards = v; },
        #tableau: (o, v) { o.tableau = v; },
        #tower: (o, v) { o.tower = v; },
        #value: (o, v) { o.value = v; },
      },
      parents: {
        smoke_9.FcApp: _M0,
        smoke_3.FcCard: _M0,
        smoke_7.FcCollapsedPile: smoke_5.FcPile,
        smoke_8.FcColumn: smoke_5.FcPile,
        smoke_0.FcDragDrop: _M0,
        smoke_5.FcPile: _M0,
        _M0: smoke_1.PolymerElement,
      },
      declarations: {
        smoke_9.FcApp: {
          #boardForSolver: const Declaration(#boardForSolver, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
          #boardId: const Declaration(#boardId, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
          #handlePileChanged: const Declaration(#handlePileChanged, Function, kind: METHOD),
          #remainingCards: const Declaration(#remainingCards, int, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
          #tableau: const Declaration(#tableau, smoke_6.Tableau, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
        },
        smoke_3.FcCard: {
          #card: const Declaration(#card, smoke_4.ViewCard, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
          #cardChanged: const Declaration(#cardChanged, Function, kind: METHOD),
        },
        smoke_7.FcCollapsedPile: const {},
        smoke_8.FcColumn: const {},
        smoke_0.FcDragDrop: {
          #dragging: const Declaration(#dragging, bool, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
        },
        smoke_5.FcPile: {
          #pile: const Declaration(#pile, smoke_6.Pile, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_1.published]),
        },
      },
      names: {
        #boardForSolver: r'boardForSolver',
        #boardId: r'boardId',
        #card: r'card',
        #cardChanged: r'cardChanged',
        #cards: r'cards',
        #cell: r'cell',
        #cells: r'cells',
        #column: r'column',
        #columns: r'columns',
        #deal: r'deal',
        #dragging: r'dragging',
        #enumerate: r'enumerate',
        #formatUrl: r'formatUrl',
        #handleCardMovementEnd: r'handleCardMovementEnd',
        #handleFreecellSolved: r'handleFreecellSolved',
        #handleLoad: r'handleLoad',
        #handlePileChanged: r'handlePileChanged',
        #handlePlaceCard: r'handlePlaceCard',
        #index: r'index',
        #isEmpty: r'isEmpty',
        #item: r'item',
        #length: r'length',
        #newBoard: r'newBoard',
        #pile: r'pile',
        #remainingCards: r'remainingCards',
        #solve: r'solve',
        #tableau: r'tableau',
        #tower: r'tower',
        #towers: r'towers',
        #value: r'value',
      }));
  configureForDeployment([
      i0.upgradeFreecellSolver,
      () => Polymer.register('fc-drag-drop', i1.FcDragDrop),
      () => Polymer.register('fc-card', i2.FcCard),
      () => Polymer.register('fc-pile', i3.FcPile),
      () => Polymer.register('fc-collapsed-pile', i4.FcCollapsedPile),
      () => Polymer.register('fc-column', i5.FcColumn),
      () => Polymer.register('fc-app', i6.FcApp),
    ]);
  i7.main();
}
